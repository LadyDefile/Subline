extends Node2D

onready var col1 = get_node("CanvasLayer/Control/VBox/HBox/Split/Col1")
onready var col2 = get_node("CanvasLayer/Control/VBox/HBox/Split/Col2")

onready var rtl				= col1.get_node("rtl")

onready var input_text 		= col2.get_node("InputText")
onready var console 		= col2.get_node("Console")

var message = ""
var line_index = 0
var lines = ["This is a ridiculously long line that I will expect my submissive to write because I am a terrible person that wants to see them suffer more than anything in the world like a true sadistic freak of nature. Unfortunately for that submissive, I have no mercy when she crosses a line."]
var count = 100
var remain = 100
var completed = 0
var add_on_typo = 0
var add_on_cheat = 0
var mult_on_cheat = 0
var cheat_mode = 0
var typo_count = 0
var realtime = false

const GREEN = "#7CFC00"
const RED = "#FF3A3A"

var remaining_line_color = GREEN

func _ready():
	get_node("CanvasLayer/Control/VBox/PanelContainer/HBoxContainer/BackButton").connect("pressed", self, "_on_back_pressed")

	input_text.connect("gui_input", self, "_on_line_input")
	input_text.connect("text_changed", self, "_on_text_changed")
	input_text.connect("text_entered", self, "_on_text_entered")

	# Decrypt the string and get the data
	var text = Global.decrypt_string(Global.text_code)
	var pack = parse_json(text)
	realtime 		= pack[Global.REALTIME_KEY]
	count 			= int(pack[Global.COUNT_KEY])
	add_on_typo 	= int(pack[Global.MISTAKE_KEY])
	add_on_cheat 	= int(pack[Global.CHEATADD_KEY])
	mult_on_cheat   = pack[Global.CHEATMLT_KEY]
	cheat_mode		= int(pack[Global.CHEATMODE_KEY])
	message 		= pack[Global.MSG_KEY]
	lines 			= pack[Global.LINES_KEY]

	remain = count
	_draw_prompt()

func _on_back_pressed():
	get_tree().change_scene("res://scenes/CodeEntry.tscn")

func _draw_prompt():
	var msg = "You have [color=%s]%d[/color] sets remaining.\n\n" % [remaining_line_color, remain]
	msg += "You have made [color=%s]%d[/color] mistakes.\n\n" % [(GREEN if typo_count == 0 else RED), typo_count]
	msg += "There are %d different lines in each set.\n\n" % lines.size()
	msg += "The current line is:\n%s" % lines[line_index]
	rtl.bbcode_text = msg
	
func _on_line_input(event: InputEvent):
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		return
		
	if event.is_action_pressed("PasteAttempt"):
		input_text.text = ""
		_out_colored("Cheating will not be rewarded here.", RED)
		_on_cheat()
		_draw_prompt()

func _on_text_changed(new_text: String):
	if not realtime or new_text.length() == 0:
		return

	if lines[line_index].substr(0, new_text.length()) != new_text:
		_out_colored(new_text, RED)

		# Disable realtime and re-enable it after the OS.alert
		# call because OS.alert seems to cause _on_text_changed to be
		# called twice which turns into an infinite loop
		realtime = false
		OS.alert("STOP. That is incorrect.")
		realtime = true
		
		input_text.text = ""
		_on_mistake()
		_draw_prompt()

func _on_text_entered(new_text: String):
	if ( len(input_text.text) == 0 ):
		return
	
	if lines[line_index] == new_text:
		_out_colored(new_text, GREEN)
		_on_success()
		
	else:
		_out_colored(new_text, RED)
		_on_mistake()

	input_text.text = ""
	_draw_prompt()

	if remain <= 0:
		Global.dom_message = message
		get_tree().change_scene("res://scenes/LinesComplete.tscn")

func _on_mistake():
	remain += add_on_typo
	remaining_line_color = RED
	typo_count += 1

func _on_success():
	line_index += 1
	if line_index >= lines.size():
		line_index = 0
		remain -= 1
	remaining_line_color = GREEN

func _on_cheat():
	remaining_line_color = RED
	if cheat_mode & Global.CHEATMODE_ORIG != 0:
		remain += count

	if cheat_mode & Global.CHEATMODE_ADD != 0:
		remain += add_on_cheat

	if cheat_mode & Global.CHEATMODE_MULT != 0:
		remain = int(remain * mult_on_cheat)

func _out(text: String):
	console.bbcode_text += text + '\n'
	
func _out_colored(text: String, color: String):
	var color_string = "[color={scolor}]{text}[/color]\n"
	var formatted = color_string.format({"scolor": color, "text": text})
	console.bbcode_text += formatted

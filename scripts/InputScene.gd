extends Node2D
onready var title_label		= get_node("CanvasLayer/Control/VBox/PanelContainer/HBoxContainer/HeaderLabel")
onready var back_button 	= get_node("CanvasLayer/Control/VBox/PanelContainer/HBoxContainer/BackButton")
onready var exit_button 	= get_node("CanvasLayer/Control/VBox/PanelContainer/HBoxContainer/ExitButton")

onready var result_page		= get_node("CanvasLayer/Control/VBox/ResultPage")
onready var entry_page 		= get_node("CanvasLayer/Control/VBox/EntryPage")

onready var col1 			= entry_page.get_node("Split/Col1")
onready var rtl				= col1.get_node("rtl")

onready var col2 			= entry_page.get_node("Split/Col2")
onready var input_text 		= col2.get_node("InputText")
onready var console 		= col2.get_node("Console")

onready var congrats_label	= result_page.get_node("VBox/Label")
onready var dom_label		= result_page.get_node("VBox/Center/DomLabel")

var message = ""
var line_index = 0
var lines = []
var line_order = []
var count = 100
var remain = 100
var completed_sentences = 0
var completed_sets = 0
var add_on_typo = 0
var add_on_cheat = 0
var mult_on_cheat = 0
var cheat_mode = 0
var mistake_count = 0
var realtime = false
var randomize_order = false

const GREEN = "#7CFC00"
const RED = "#FF3A3A"

var remaining_line_color = GREEN

func _ready():
	back_button.connect("pressed", self, "_on_pressed", [back_button])
	exit_button.connect("pressed", self, "_on_pressed", [exit_button])

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
	randomize_order = pack[Global.RAND_KEY]

	remain = count
	_randomize_set()
	_draw_prompt()
	input_text.grab_focus()

func _on_pressed(button: Button):
	if button == back_button:
		get_tree().change_scene("res://scenes/CodeEntry.tscn")

	elif button == exit_button:
		get_tree().change_scene("res://scenes/RoleScene.tscn")

func _draw_prompt():
	var msg = "You have [color=%s]%d[/color] sets remaining.\n\n" % [remaining_line_color, remain]
	msg += "You have made [color=%s]%d[/color] mistakes.\n\n" % [(GREEN if mistake_count == 0 else RED), mistake_count]
	msg += "There are %d different lines in each set.\n\n" % lines.size()
	msg += "The current line is:\n%s" % _get_line()
	rtl.bbcode_text = msg

func _randomize_set():
	line_order = range(0, len(lines))
	randomize()
	line_order.shuffle()
	print(line_order)

func _get_line():
	# If randomized return the line that is at the random index stored in line_order
	if randomize_order:
		return lines[line_order[line_index]]
	
	# Return the line
	else:
		return lines[line_index]
	
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
	
	if _get_line() == new_text:
		_out_colored(new_text, GREEN)
		_on_success()
		
	else:
		_out_colored(new_text, RED)
		_on_mistake()

	input_text.text = ""
	_draw_prompt()

	if remain <= 0:
		_show_results()

func _on_mistake():
	remain += add_on_typo
	remaining_line_color = RED
	mistake_count += 1

func _on_success():
	line_index += 1
	completed_sentences += 1
	if line_index >= lines.size():
		line_index = 0
		remain -= 1
		completed_sets += 1
		_randomize_set()
	
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

func _show_results():
	# Hide the entry form
	entry_page.visible = false;
	back_button.visible = false;

	# Display the result page
	title_label.text = "Subline - Results"
	congrats_label.text = "Congratulations! "
	if lines.size() > 1:
		congrats_label.text += "You completed %d sets of %d lines with " % [completed_sets, lines.size()]
	else:
		congrats_label.text += "You completed %d lines with " % completed_sentences

	if mistake_count > 0:
		congrats_label.text += "%d mistakes. " % mistake_count
	else:
		congrats_label.text += "no mistakes. "
	
	if message.length() > 0:
		congrats_label.text += "\nA message to you from your Dominant(s):"
		dom_label.text = message
	
	exit_button.visible = true
	result_page.visible = true
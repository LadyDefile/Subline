extends Control

onready var input_text = get_node("VBox/InputText")
onready var console = get_node("VBox/Console")
onready var count_label = get_node("VBox/CountLabel")

var line = "This is a ridiculously long line that I will expect my submissive to write because I am a terrible person that wants to see them suffer more than anything in the world like a true sadistic freak of nature. Unfortunately for that submissive, I have no mercy when she crosses a line."
var count = 100
var remain = 100
var completed = 0
var addOnTypo = 5

const GREEN = "#7CFC00"
const RED = "#F07000"

func _ready():
	var _b = input_text.connect("gui_input", self, "_onLineInput")
	set_count(count)
	var msg = "Write the following line %d times:" % count
	get_node("VBox/PreviewLabel").text = msg + "\n" + line
	
func _onLineInput(event: InputEvent):
	if event is InputEventMouseMotion:
		return
	elif event is InputEventMouseButton:
		return
		
	if event.is_action_pressed("PasteAttempt"):
		print_debug("Paste")
		console.out_colored("I see you attempted to cheat.", RED)
		input_text.text = ""
		
	if event is InputEventKey:
		if event.scancode == KEY_ENTER:
			if ( len(input_text.text) == 0 ):
				return
			
			if ( line == input_text.text ):
				console.out_colored(input_text.text, GREEN)
				set_count(count-1)
			else:
				console.out_colored(input_text.text, RED)
				set_count(count+addOnTypo)
			input_text.text = ""

func set_count(n):
	count = n
	count_label.text = "Remaining: %d" % count

extends Node2D

onready var col1 = get_node("CanvasLayer/Control/HBox/Col1")
onready var col2 = get_node("CanvasLayer/Control/HBox/Col2")

onready var realtime = col1.get_node("RealTime")
onready var line_count = col1.get_node("LineCount/SpinBox")
onready var typo_add = col1.get_node("AddCount/SpinBox")

onready var cheat_mode_orig = col1.get_node("AddOrig")
onready var cheat_mode_add = col1.get_node("CheatMode/Add")
onready var cheat_add = col1.get_node("CheatMode/CheatAdd")
onready var cheat_mode_mult = col1.get_node("CheatMode/MultiplyBy")
onready var cheat_mult = col1.get_node("CheatMode/CheatMult")

onready var pass_text = col2.get_node("PassLine")
onready var line_text = col2.get_node("InputLines")
onready var pack_button = col2.get_node("Buttons/PackButton")
onready var exit_button = col2.get_node("Buttons/ExitButton")

func _ready():
	pass_text.connect("text_changed", self, "_on_text_changed")
	line_text.connect("text_changed", self, "_on_text_changed", [""])
	pack_button.connect("pressed", self, "_on_press", [pack_button])
	exit_button.connect("pressed", self, "_on_press", [exit_button])

func _on_text_changed(_text: String):
	pack_button.disabled = pass_text.text.length() == 0 or line_text.text.length() == 0
	
func _on_press(button: Button):
	if button == pack_button:
		var pack = Global.encryt_string(_dump())
		Global.text_code = pack;
		line_text.text = pack

	elif button == exit_button:
		var _x = get_tree().change_scene("res://scenes/RoleScene.tscn")

func _dump():
	var result = {}
	result[Global.REALTIME_KEY] = realtime.pressed
	result[Global.COUNT_KEY] = line_count.value
	result[Global.MISTAKE_KEY] = typo_add.value
	result[Global.CHEATADD_KEY] = cheat_add.value
	result[Global.CHEATMLT_KEY] = cheat_mult.value
	
	result[Global.CHEATMODE_KEY] = 0
	if cheat_mode_orig.pressed:
		result[Global.CHEATMODE_KEY] |= Global.CHEATMODE_ORIG

	if cheat_mode_add.pressed:
		result[Global.CHEATMODE_KEY] |= Global.CHEATMODE_ADD

	if cheat_mode_mult.pressed:
		result[Global.CHEATMODE_KEY] |= Global.CHEATMODE_MULT

	result[Global.MSG_KEY] = pass_text.text
	result[Global.LINES_KEY] = line_text.text.split("\n", false)
	
	return JSON.print(result)

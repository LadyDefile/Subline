extends Node2D

onready var dom_button = get_node("CanvasLayer/Control/Center/Panel/VBox/DomButton")
onready var sub_button = get_node("CanvasLayer/Control/Center/Panel/VBox/SubButton")
onready var opt_button = get_node("CanvasLayer/Control/Center/Panel/VBox/OptButton")
onready var con = get_node("CanvasLayer/Control") as Control

func _ready():
	dom_button.connect("pressed", self, "_on_button_pressed", [dom_button])
	sub_button.connect("pressed", self, "_on_button_pressed", [sub_button])
	opt_button.connect("pressed", self, "_on_button_pressed", [opt_button])
	
	
func _on_button_pressed(button):
	var path = ""
	if button == dom_button:
		path = "res://scenes/CreateScene.tscn"
	
	elif button == sub_button:
		path = "res://scenes/CodeEntry.tscn"

	elif button == opt_button:
		path = "res://scenes/Settings.tscn"

	else:
		return

	var _x = get_tree().change_scene(path)

extends Node2D

onready var dom_button = get_node("CanvasLayer/Control/Center/Panel/VBox/DomButton")
onready var sub_button = get_node("CanvasLayer/Control/Center/Panel/VBox/SubButton")

func _ready():
	dom_button.connect("pressed", self, "on_button_pressed", [0])
	sub_button.connect("pressed", self, "on_button_pressed", [1])
	
func on_button_pressed(id):
	var path = ""
	if id == 0:
		path = "res://scenes/CreateScene.tscn"
	
	elif id == 1:
		path = "res://scenes/CodeEntry.tscn"

	else:
		return

	var _x = get_tree().change_scene(path)

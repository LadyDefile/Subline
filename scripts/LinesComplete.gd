extends Node2D

onready var dom_label = get_node("CanvasLayer/Control/pCon/VBox/Center/DomLabel")
onready var home_button = get_node("CanvasLayer/Control/pCon/VBox/HBox/HomeButton")

func _ready():
    dom_label.text = Global.dom_message
    home_button.connect("pressed", self, "_on_pressed", [home_button])

func _on_pressed(button: Button):
    if button == home_button:
        Global.dom_message = ""
        get_tree().change_scene("res://scenes/RoleScene.tscn")
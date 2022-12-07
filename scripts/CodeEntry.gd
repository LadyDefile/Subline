extends Node2D

onready var global = get_node("/root/Global")
onready var code_text = get_node("CanvasLayer/Control/Center/Panel/VBox/TextEdit")
onready var ok_button = get_node("CanvasLayer/Control/Center/Panel/VBox/HBox/Ok")
onready var cancel_button = get_node("CanvasLayer/Control/Center/Panel/VBox/HBox/Cancel")

func _ready():
    code_text.connect("text_changed", self, "text_changed")
    code_text.text = Global.text_code
    text_changed()

    ok_button.connect("pressed", self, "on_pressed", [ok_button])

    cancel_button.connect("pressed", self, "on_pressed", [cancel_button])

func text_changed():
    ok_button.disabled = code_text.text.length() == 0

func on_pressed(button: Button):
    if button == ok_button:
        global.text_code = code_text.text;
        var _x = get_tree().change_scene("res://scenes/InputScene.tscn")

    elif button == cancel_button:
        var _x = get_tree().change_scene("res://scenes/RoleScene.tscn")
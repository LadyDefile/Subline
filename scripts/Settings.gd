extends Node2D

onready var stay_puft = get_node("CanvasLayer/Control/Center/pCon/VBox/StayPuft")
onready var open_sans = get_node("CanvasLayer/Control/Center/pCon/VBox/OpenSans")
onready var roboto = get_node("CanvasLayer/Control/Center/pCon/VBox/Roboto")
onready var con = get_node("CanvasLayer/Control") as Control
onready var back_button = get_node("CanvasLayer/Control/Center/pCon/VBox/HBoxContainer/Button")

func _ready():
    stay_puft.pressed = Global.font_selection == "staypuft"
    open_sans.pressed = Global.font_selection == "opensans"
    roboto.pressed = Global.font_selection == "roboto"

    stay_puft.connect("pressed", self, "_on_font_changed", [stay_puft])
    open_sans.connect("pressed", self, "_on_font_changed", [open_sans])
    roboto.connect("pressed", self, "_on_font_changed", [roboto])
    back_button.connect("pressed", self, "_on_back_pressed")

func _on_font_changed(node: Node):
    if node == stay_puft:
        Global.font_selection = "staypuft"
        con.theme.default_font = load("res://fonts/staypuft_normal.tres")
        con.theme.get_type_variation_base("LargeLabel")
        con.theme.set_font("font", "LargeLabel", load("res://fonts/staypuft_large.tres"))
    elif node == open_sans:
        Global.font_selection = "opensans"
        con.theme.default_font = load("res://fonts/opensans_normal.tres")
        con.theme.set_font("font", "LargeLabel", load("res://fonts/opensans_large.tres"))
    elif node == roboto:
        Global.font_selection = "roboto"
        con.theme.default_font = load("res://fonts/roboto_normal.tres")
        con.theme.set_font("font", "LargeLabel", load("res://fonts/roboto_large.tres"))
    
func _on_back_pressed():
    get_tree().change_scene("res://scenes/RoleScene.tscn")
extends Node2D

onready var back_button     = get_node("CanvasLayer/Control/Center/VBox/Bar/HBox/Button")
onready var font_options    = get_node("CanvasLayer/Control/Center/VBox/Content/VBox/Font/OptionButton") as OptionButton
onready var packaged_fonts  = ["StayPuft", "OpenSans-Regular", "Roboto-Regular"]
onready var extra_fonts     = Global.get_font_list()

func _ready():
    # Add the default fonts to the list
    for i in packaged_fonts.size():
        font_options.add_item(packaged_fonts[i], i)
        if Global.font_selection == packaged_fonts[i]:
            font_options.selected = i
    
    # Add any extra fonts to the list while offsetting the id of the option
    # to come after the built-in font list.
    for i in extra_fonts.size():
        font_options.add_item(extra_fonts[i].get_basename(), i + packaged_fonts.size())
        if Global.font_selection == extra_fonts[i].get_basename():
            font_options.selected = i + packaged_fonts.size()
    
    font_options.connect("item_selected", self, "_on_font_selected")
    back_button.connect("pressed", self, "_on_back_pressed")


func _on_font_selected(id: int):
    if id < packaged_fonts.size():
        Global.font_selection = packaged_fonts[id]
    else:
        id -= packaged_fonts.size()
        if id < extra_fonts.size():
            Global.font_selection = extra_fonts[id].get_basename()
        else:
            return
    
    Global.update_font()
    Global.save_config()
    
func _on_back_pressed():
    get_tree().change_scene("res://scenes/RoleScene.tscn")
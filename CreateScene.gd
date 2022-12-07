extends Control
onready var global = get_node("/root/Global")
onready var realtime = get_node("HBox/Col1/RealTime")
onready var line_count = get_node("HBox/Col1/LineCount/SpinBox")
onready var typo_add = get_node("HBox/Col1/AddCount/SpinBox")
onready var pass_text = get_node("HBox/Col2/PassLine")
onready var line_text = get_node("HBox/Col2/InputLines")
onready var pack_button = get_node("HBox/Col2/PackButton")

func _ready():
	pack_button.connect("pressed", self, "onPackPressed")
	
func onPackPressed():
	var pack = global.encryt_string(dump(), "BadGirl")
	line_text = pack

func dump():
	var result = {}
	result["realtime"] = realtime.pressed
	result["line_count"] = line_count.value
	result["typo_add"] = line_count.value
	result["passphrase"] = pass_text.text
	result["lines"] = line_text.text.split("\n", false)
	
	return JSON.print(result)

func data_test(hex: String, bytes: PoolByteArray):
	var character

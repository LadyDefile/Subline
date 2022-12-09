extends Node

var text_code = ""
var font_selection = "staypuft"

const ENC_KEY = "MistakesWereMade"

const LINES_KEY = "lines"
const MSG_KEY = "message"
const REALTIME_KEY = "realtime"
const MISTAKE_KEY = "add_on_mistake"
const CHEATADD_KEY = "add_on_cheat"
const CHEATMLT_KEY = "mult_on_cheat"
const CHEATMODE_KEY = "cheat_mode"
const COUNT_KEY = "count"

const CHEATMODE_ADD = 1
const CHEATMODE_MULT = 2
const CHEATMODE_ORIG = 4

func initialize_folder_structure():
	var dir = Directory.new()
	if not dir.dir_exists("user://fonts"):
		dir.open("user://")
		dir.make_dir("fonts")

func encryt_string(text: String) -> String:
	
	var text_bytes = text.to_utf8()
	var key_bytes = ENC_KEY.to_utf8()
	var iKey = 0
	
	var output = ""
	for iByte in text_bytes.size():
		text_bytes[iByte] += key_bytes[iKey]
		iKey +=1
		if iKey >= key_bytes.size():
			iKey = 0
		if ( text_bytes[iByte] > 255 ):
			print("%X" % text_bytes[iByte])
		output += "%X" % text_bytes[iByte]
	
	return output

func decrypt_string(text: String) -> String:
	var chars = []
	for i in range(0, text.length(), 2):
		var hex = "0x"+text.substr(i, 2)
		var val = hex.hex_to_int()
		chars.append( val )
	
	var key_bytes = ENC_KEY.to_utf8()
	var iKey = 0

	var output = ""
	for i in chars.size():
		output += char(chars[i] - key_bytes[iKey])
		iKey+=1

		if iKey >= key_bytes.size():
			iKey = 0

	return output

func save_config():
	var config = ConfigFile.new()
	config.set_value("Global", "font_selection", font_selection)
	config.save("user://config.cfg")

func load_config():
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")

	if err != OK:
		return
	
	font_selection = config.get_value("Global", "font_selection")
	update_font()

func get_font_list():
	var files = []
	var dir = Directory.new()
	dir.open("user://fonts/")
	dir.list_dir_begin()

	# Get only the font files
	while true:
		var file = dir.get_next()
		if file == "":
			break;
		elif file.ends_with(".ttf") or file.ends_with(".otf"):
			files.append(file)
		
	return files
	

func update_font():
	# Attempt to get the font data from the file.
	var font_data = null
	if font_selection in ["OpenSans-Regular", "Roboto-Regular", "StayPuft"]:
		var f = File.new()
		if f.file_exists("res://fonts/%s.ttf" % font_selection):
			font_data = ResourceLoader.load("res://fonts/%s.ttf" % font_selection)

		elif f.file_exists("res://fonts/%s.otf" % font_selection):
			font_data = ResourceLoader.load("res://fonts/%s.otf" % font_selection)
	
	else:
		var f = File.new()
		if f.file_exists("user://fonts/%s.ttf" % font_selection):
			font_data = ResourceLoader.load("user://fonts/%s.ttf" % font_selection)

		if f.file_exists("user://fonts/%s.otf" % font_selection):
			font_data = ResourceLoader.load("user://fonts/%s.otf" % font_selection)

	# Upon failing to get font data, abort
	if font_data == null:
		return
	
	# Create a normal and large font data.
	var font_normal = DynamicFont.new()
	font_normal.font_data = font_data
	font_normal.size = 16

	var font_large = DynamicFont.new()
	font_large.font_data = font_data
	font_large.size = 24

	# Apply the new font to the theme.
	var theme = ResourceLoader.load("res://basic_theme.tres")
	theme.default_font = font_normal
	theme.set_font("font", "LargeLabel", font_large)
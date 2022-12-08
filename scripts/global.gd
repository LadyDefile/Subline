extends Node

var text_code = ""
var dom_message = ""
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
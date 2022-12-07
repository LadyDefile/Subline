extends Node

func encryt_string(text: String, key: String) -> String:
	
	var text_bytes = text.to_utf8()
	var key_bytes = key.to_utf8()
	var iKey = 0
	
	var output = ""
	for iByte in text_bytes.size():
		text_bytes[iByte] += key_bytes[iKey]
		iKey +=1
		if iKey >= key_bytes.size():
			iKey = 0
			if ( text_bytes[iByte] > 255 ):
				print("%X" % text_bytes[iByte])
		output += "%X " % text_bytes[iByte]
	
	return output

func decrypt_string(text: String, key: String) -> String:
	return ""

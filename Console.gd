extends RichTextLabel

func out(text: String):
	bbcode_text += text + '\n'
	
func out_colored(text: String, color: String):
	var color_string = "[color={scolor}]{text}[/color]\n"
	var formatted = color_string.format({"scolor": color, "text": text})
	bbcode_text += formatted

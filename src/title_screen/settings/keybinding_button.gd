class_name KeyBindingButton
extends Button

export (String) var action = ""

func _ready():
	refresh_label()


func refresh_label():
	text = ""
	var events = InputMap.get_action_list(action)

	for e in events:
		if e is InputEventKey:
			text = e.as_text()
			break

	if text == "":
		text = tr("ui_key_none")

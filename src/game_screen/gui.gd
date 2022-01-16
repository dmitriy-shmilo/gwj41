extends Node
class_name Gui

onready var _treasure_label = $"TreasureLabel"


func update_score(current: int) -> void:
	var text = "x000"
	
	if current < 1000:
		text = "x%03d" % current
	elif current < 1000000:
		text = "x%0.1fK" % (float(current) / 1000.0)
	else:
		text = "x%0.1fM" % (float(current) / 1000000.0)

	_treasure_label.text = text

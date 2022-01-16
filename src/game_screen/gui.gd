extends Node
class_name Gui

const LIFE_ICON_SCENE = preload("res://game_screen/life_icon.tscn")

onready var _treasure_label = $"TreasureLabel"
onready var _lives_container = $"LivesContainer"

func update_score(current: int) -> void:
	var text = "x000"
	
	if current < 1000:
		text = "x%03d" % current
	elif current < 1000000:
		text = "x%0.1fK" % (float(current) / 1000.0)
	else:
		text = "x%0.1fM" % (float(current) / 1000000.0)

	_treasure_label.text = text


func update_lives(current: int, total: int) -> void:
	if current < 0 or total < 0:
		return

	var life_icons = _lives_container.get_children()
	if life_icons.size() < total:
		for i in range(total - life_icons.size()):
			_lives_container.add_child(LIFE_ICON_SCENE.instance())
	elif life_icons.size() > total:
		for i in range(life_icons.size() - total):
			life_icons[i].queue_free()
		life_icons.resize(total)
	
	for i in range(total):
		var node = _lives_container.get_child(i)
		# TODO: show empty life
		if i < current:
			node.visible = true
		else:
			node.visible = false

extends Node2D


const TREASURE_SCENES = [
	preload("res://game_screen/treasure1.tscn"),
	preload("res://game_screen/treasure1.tscn"),
	preload("res://game_screen/treasure1.tscn"),
	preload("res://game_screen/treasure2.tscn"),
	preload("res://game_screen/treasure2.tscn"),
	preload("res://game_screen/treasure3.tscn"),
	preload("res://game_screen/powerup.tscn"),
	preload("res://game_screen/powerup.tscn")
]

export(bool) var allow_empty = true

func _ready() -> void:
	var scene
	if allow_empty:
		var i = randi() % (TREASURE_SCENES.size() + 1)
		if i == 0:
			return
		scene = TREASURE_SCENES[i - 1]
	else:
		scene = TREASURE_SCENES[randi() % TREASURE_SCENES.size()]
	
	var item = scene.instance()
	var game_screen = get_node("/root/GameScreen")
	item.connect("collected", game_screen, "_on_item_collected")
	item.position = position
	item.add_to_group("items", true)
	get_parent().call_deferred("add_child", item)

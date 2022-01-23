extends Node2D


const ENEMY_SCENES = [
	preload("res://game_screen/enemy1.tscn"),
	preload("res://game_screen/enemy2.tscn")
]

export(bool) var allow_empty = true

func _ready() -> void:
	var scene
	if allow_empty:
		var i = randi() % (ENEMY_SCENES.size() + 1)
		if i == 0:
			return
		scene = ENEMY_SCENES[i - 1]
	else:
		scene = ENEMY_SCENES[randi() % ENEMY_SCENES.size()]
	
	var enemy = scene.instance()
	var game_screen = get_node("/root/GameScreen")
	enemy.connect("collected", game_screen, "_on_item_collected")
	enemy.position = position
	enemy.add_to_group("items", true)
	get_parent().call_deferred("add_child", enemy)

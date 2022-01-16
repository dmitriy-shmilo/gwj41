extends Node2D

const SPAWN_OFFSET = 100
const TREASURE_SCENE = preload("res://game_screen/treasure.tscn")
const ENEMY_SCENE = preload("res://game_screen/enemy.tscn")

onready var _pause_container: ColorRect = $"Gui/PauseContainer"
onready var _gui: Gui = $"Gui"

var _score = 0

func _ready() -> void:
	_spawn(TREASURE_SCENE)


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true


func _spawn(scene) -> void:
	var item = scene.instance()
	item.global_position = Vector2(get_viewport().size.x + SPAWN_OFFSET, randi() % 10 * get_viewport().size.y / 10 + 8)
	item.connect("collected", self, "_on_item_collected")
	add_child(item)


func _set_score(value: int) -> void:
	_score = value
	_gui.update_score(_score)


func _on_item_collected(item) -> void:
	if item is Treasure:
		_set_score(_score + item.value)
		item.disappear()
	elif item is Enemy:
		item.disappear()


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false


func _on_SpawnTimer_timeout() -> void:
	# TODO: spawn more stuff with progress
	match randi() % 10:
		0:
			_spawn(TREASURE_SCENE)
		1:
			_spawn(ENEMY_SCENE)

extends Node2D

const SPAWN_OFFSET = 100
const TREASURE_SCENE = preload("res://game_screen/treasure.tscn")
const ENEMY_SCENE = preload("res://game_screen/enemy.tscn")

onready var _pause_container: ColorRect = $"Gui/PauseContainer"
onready var _gui: Gui = $"Gui"

var _max_lives = 3
var _lives = _max_lives
var _score = 0


func _ready() -> void:
	UserSaveData.is_running = true
	UserSaveData.save_data()
	_spawn(TREASURE_SCENE)
	_gui.update_lives(_lives, _max_lives)


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
	UserSaveData.last_recovered_treasure = value
	_gui.update_score(_score)


func _set_lives(value: int) -> void:
	# TODO: update stats and fade
	if value < 1:
		_end_run()

	_lives = value
	_gui.update_lives(value, _max_lives)


func _end_run() -> void:
	UserSaveData.current_expedition += 1
	UserSaveData.is_running = false
	UserSaveData.save_data()
	get_tree().change_scene("res://score_screen/score_screen.tscn")


func _on_item_collected(item) -> void:
	if item is Treasure:
		_set_score(_score + item.value)
		item.disappear()
	elif item is Enemy:
		_set_lives(_lives - 1)
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

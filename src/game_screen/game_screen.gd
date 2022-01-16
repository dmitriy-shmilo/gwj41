extends Node2D

const SPAWN_OFFSET = 100
const TREASURE_SCENE = preload("res://game_screen/treasure.tscn")

onready var _pause_container: ColorRect = $"Gui/PauseContainer"


func _ready() -> void:
	_spawn()


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true


func _spawn() -> void:
	var item = TREASURE_SCENE.instance()
	item.global_position = Vector2(get_viewport().size.x + SPAWN_OFFSET, randi() % 10 * get_viewport().size.y / 10 + 8)
	add_child(item)


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false


func _on_SpawnTimer_timeout() -> void:
	if randi() % 9 != 0:
		return

	_spawn()

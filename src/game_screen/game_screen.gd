extends Node2D

const METERS_PER_PIXEL = 0.02
const SPAWN_OFFSET = 100
const TREASURE_SCENE = preload("res://game_screen/treasure.tscn")
const ENEMY_SCENE = preload("res://game_screen/enemy.tscn")
const INVINCIBILITY_TIME = 2.0

onready var _pause_container: ColorRect = $"Gui/PauseContainer"
onready var _gui: Gui = $"Gui"
onready var _submarine: Submarine = $"Submarine"

var _max_lives = 1
var _lives = 1
var _max_oxygen = 60
var _oxygen = 60
var _oxygen_consumption = 1.0
var _score = 0
var _distance = 0
var _speed = 50
var _invincibility_left = 0.0


func _ready() -> void:
	_setup()
	UserSaveData.is_running = true
	UserSaveData.save_data()
	_spawn(TREASURE_SCENE)
	_gui.update_lives(_lives, _max_lives)
	_gui.show_run_title(tr("txt_run_title") % (UserSaveData.current_expedition + 1))


func _unhandled_input(event):
	if event.is_action("system_pause"):
		get_tree().paused = true
		_pause_container.visible = true


func _process(delta: float) -> void:
	if _invincibility_left > 0.0:
		_invincibility_left -= delta
		
		if _invincibility_left <= 0.0:
			_submarine.stop_blinking()


func _setup() -> void:
	var upgrades = UpgradeRegistry.get_purchased_upgrades()
	
	for upgrade in upgrades:
		match upgrade.type:
			Upgrade.Type.health:
				_max_lives += upgrade.strength
			Upgrade.Type.oxygen:
				_max_oxygen += upgrade.strength
			Upgrade.Type.ascend_speed:
				_submarine.up_speed += upgrade.strength
			Upgrade.Type.descend_speed:
				_submarine.down_speed += upgrade.strength
	
	_lives = _max_lives
	_oxygen = _max_oxygen


func _spawn(scene) -> void:
	var item = scene.instance() as Collectable
	item.global_position = Vector2(get_viewport().size.x + SPAWN_OFFSET, randi() % 10 * get_viewport().size.y / 10 + 8)
	item.connect("collected", self, "_on_item_collected")
	item.add_to_group("items", true)
	item.velocity = Vector2(-_speed, 0)
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


func _set_oxygen(value: float) -> void:
	_oxygen = value
	_gui.update_oxygen(_oxygen, _max_oxygen)
	
	if value <= 0:
		_end_run()


func _set_distance(value: float) -> void:
	_distance = value
	_gui.update_distance(_distance)


func _end_run() -> void:
	UserSaveData.best_progress = max(UserSaveData.best_progress, _distance)
	UserSaveData.current_expedition += 1
	UserSaveData.is_running = false
	UserSaveData.save_data()
	get_tree().change_scene("res://score_screen/score_screen.tscn")


func _on_item_collected(item) -> void:
	if item is Treasure:
		_set_score(_score + item.value)
		item.disappear()
	elif item is Enemy:
		if _invincibility_left <= 0.0:
			_invincibility_left = INVINCIBILITY_TIME
			_set_lives(_lives - 1)
			_submarine.start_blinking()
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


func _on_ProgressTimer_timeout() -> void:
	_set_distance(_distance + _speed * METERS_PER_PIXEL)
	_set_oxygen(_oxygen - _oxygen_consumption)
	

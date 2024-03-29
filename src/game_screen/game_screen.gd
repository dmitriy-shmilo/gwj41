extends Node2D

const METERS_PER_PIXEL = 0.02
const SPAWN_OFFSET = 100
const POWERUP_SCENE = preload("res://game_screen/powerup.tscn")
const INVINCIBILITY_TIME = 2.0

const CHUNK_SCENES = [
	preload("res://game_screen/chunks/chunk1.tscn"),
	preload("res://game_screen/chunks/chunk2.tscn"),
	preload("res://game_screen/chunks/chunk3.tscn"),
	preload("res://game_screen/chunks/chunk4.tscn"),
	preload("res://game_screen/chunks/chunk5.tscn")
]

onready var _pause_container: ColorRect = $"Gui/PauseContainer"
onready var _gui: Gui = $"Gui"
onready var _submarine: Submarine = $"Submarine"
onready var _soundtrack_player: AudioStreamPlayer = $"SoundtrackPlayer"
onready var _pickup_sound_player: AudioStreamPlayer = $"PickupSoundPlayer"
onready var _damage_sound_player: AudioStreamPlayer = $"DamageSoundPlayer"
onready var _end_sound_player: AudioStreamPlayer = $"EndSoundPlayer"
onready var _powerup_sound_player: AudioStreamPlayer = $"PowerupSoundPlayer"
onready var _screen_shaker: Shaker = $"ScreenShaker"
onready var _speed_powerup_timer: Timer = $"SpeedPowerupTimer"
onready var _game_over_timer: Timer = $"GameOverTimer"
onready var _fader: Fader = $"Fader"
onready var _parallax: Parallax = $"ParallaxBackground"

var _max_lives = 1
var _lives = 1
var _max_oxygen = 60
var _oxygen = 60
var _oxygen_consumption = 1.0
var _score = 0
var _distance = 0
var _base_speed = 70.0
var _speed = _base_speed
var _invincibility_left = 0.0
var _current_powerup: Powerup = null
var _game_over = false

func _ready() -> void:
	_set_speed(_base_speed)
	_setup()
	_soundtrack_player.play(UserSaveData.soundtrack_time)
	UserSaveData.is_running = true
	UserSaveData.save_data()
	_spawn_chunk(CHUNK_SCENES[randi() % CHUNK_SCENES.size()])
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
			Upgrade.Type.vspeed:
				_submarine.base_up_speed += upgrade.strength
				_submarine.base_down_speed += upgrade.strength
			_:
				continue
	
	_lives = _max_lives
	_oxygen = _max_oxygen

func _spawn_chunk(scene) -> void:
	var chunk = scene.instance() as Chunk
	chunk.global_position = Vector2(get_viewport().size.x + SPAWN_OFFSET, 0)
	chunk.connect("end_visible", self, "_on_chunk_ended")
	chunk.add_to_group("chunks", true)
	chunk.velocity = Vector2(-_speed, 0)
	add_child(chunk)


func _set_speed(value: float) -> void:
	_speed = value
	_parallax.speed = value
	for item in get_tree().get_nodes_in_group("chunks"):
		(item as Chunk).velocity = Vector2(-_speed, 0)

	for item in get_tree().get_nodes_in_group("items"):
		(item as Collectable).velocity = Vector2(-_speed, 0)


func _set_score(value: int) -> void:
	_score = value
	UserSaveData.last_recovered_treasure = value
	_gui.update_score(_score)


func _set_powerup(value: Powerup) -> void:
	_current_powerup = value
	_gui.update_powerup(value)


func _set_lives(value: int) -> void:
	_lives = value
	_gui.update_lives(value, _max_lives)

	if not _game_over and value < 1:
		_gui.show_run_title(tr("txt_no_lives"))
		_end_run()


func _set_oxygen(value: float) -> void:
	_oxygen = value
	_gui.update_oxygen(_oxygen, _max_oxygen)
	
	if not _game_over and value <= 0:
		_gui.show_run_title(tr("txt_no_oxygen"))
		_end_run()


func _set_distance(value: float) -> void:
	_distance = value
	_gui.update_distance(_distance)


func _end_run() -> void:
	_game_over = true
	_game_over_timer.start()
	_set_speed(0.0)
	_submarine.emerge()
	_soundtrack_player.stop()
	_end_sound_player.play()
	UserSaveData.best_progress = max(UserSaveData.best_progress, _distance)
	UserSaveData.current_expedition += 1
	UserSaveData.is_running = false
	UserSaveData.soundtrack_time = _soundtrack_player.get_playback_position()


func _on_chunk_ended(chunk) -> void:
	_spawn_chunk(CHUNK_SCENES[randi() % CHUNK_SCENES.size()])


func _on_item_collected(item) -> void:
	if item is Treasure:
		_pickup_sound_player.play()
		_set_score(_score + item.value)
		item.disappear()
	elif item is PowerupCollectable:
		_pickup_sound_player.play()
		_set_powerup(item.powerup)
		item.disappear()
	elif item is Enemy:
		if _invincibility_left <= 0.0:
			_damage_sound_player.play()
			_invincibility_left = INVINCIBILITY_TIME
			_set_lives(_lives - 1)
			_submarine.start_blinking()
			if Settings.screenshake:
				_screen_shaker.shake_vertical(self, "position", 25)
		item.disappear()


func _on_QuitButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed():
	_pause_container.visible = false
	get_tree().paused = false


func _on_ProgressTimer_timeout() -> void:
	_set_distance(_distance + _speed * METERS_PER_PIXEL)
	_set_oxygen(_oxygen - _oxygen_consumption)
	

func _on_Submarine_special_pressed(sender) -> void:
	if _current_powerup == null:
		return
	
	_powerup_sound_player.play()
	match _current_powerup.type:
		Powerup.Type.health:
			_set_lives(min(_lives + _current_powerup.strength, _max_lives))
		Powerup.Type.oxygen:
			_set_oxygen(min(_oxygen + _current_powerup.strength, _max_oxygen))
		Powerup.Type.hspeed:
			_set_speed(_base_speed + _current_powerup.strength)
			_speed_powerup_timer.start()
		Powerup.Type.vspeed:
			_submarine.modify_vspeed(_current_powerup.strength)
			_speed_powerup_timer.start()
	
	_set_powerup(null)


func _on_SpeedPowerupTimer_timeout() -> void:
	_set_speed(_base_speed)
	_submarine.modify_vspeed(0.0)


func _on_GameOverTimer_timeout() -> void:
	_fader.fade_out()
	yield(_fader, "fade_out_completed")
	UserSaveData.save_data()
	get_tree().change_scene("res://score_screen/score_screen.tscn")

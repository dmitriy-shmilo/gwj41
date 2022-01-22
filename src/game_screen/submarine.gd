extends KinematicBody2D
class_name Submarine

const BASE_SPEED = 50.0

signal special_pressed(sender)

export(float) var base_up_speed = BASE_SPEED
export(float) var base_down_speed = BASE_SPEED
export(Vector2) var direction = Vector2.ZERO

onready var _effect_player: AnimationPlayer = $"EffectPlayer"
onready var _movement_sound_player: AudioStreamPlayer = $"MovementSoundPlayer"
onready var _body_shape: CollisionShape2D = $"BodyShape"

var _current_button: ActionButton
var _up_speed = base_up_speed
var _down_speed = base_down_speed
var _is_emerging = false


func _ready() -> void:
	for upgrade in UpgradeRegistry.get_purchased_upgrades():
		if upgrade.type == Upgrade.Type.vspeed:
			base_up_speed += upgrade.strength
			base_down_speed += upgrade.strength


func _process(delta: float) -> void:
	if _is_emerging:
		move_and_slide(Vector2.UP * _up_speed)
		return
		
	if not Input.is_action_pressed("ui_accept"):
		_movement_sound_player.stop()
		return
	
	if _current_button == null:
		return
	
	if _current_button.action.type == ButtonAction.Type.special:
		emit_signal("special_pressed", self)
		return

	if direction == Vector2.ZERO:
		return

	if direction == Vector2.UP:
		if not _movement_sound_player.playing:
			_movement_sound_player.stream = preload("res://assets/sound/sfx_sub_ascend.wav")
			_movement_sound_player.play()
		move_and_slide(direction * _up_speed)
		return
	
	if direction == Vector2.DOWN:
		if not _movement_sound_player.playing:
			_movement_sound_player.stream = preload("res://assets/sound/sfx_sub_descend.wav")
			_movement_sound_player.play()
		move_and_slide(direction * _down_speed)


func emerge() -> void:
	_up_speed = BASE_SPEED * 2.0
	_body_shape.set_deferred("disabled", true)
	_is_emerging = true


func modify_vspeed(modifier: float) -> void:
	_down_speed = base_down_speed + modifier
	_up_speed = base_up_speed + modifier


func start_blinking() -> void:
	_effect_player.play("blink")


func stop_blinking() -> void:
	_effect_player.play("RESET")


func ascend() -> void:
	direction = Vector2.UP


func descend() -> void:
	direction = Vector2.DOWN


func go_steady() -> void:
	_movement_sound_player.stop()
	direction = Vector2.ZERO


func _on_Button_targeted(sender) -> void:
	_current_button = sender
	_current_button.toggle_hint(true)
	
	match sender.action.type:
		ButtonAction.Type.ascend:
			ascend()
		ButtonAction.Type.descend:
			descend()
		_:
			go_steady()


func _on_Button_untargeted(sender) -> void:
	_current_button.toggle_hint(false)
	_current_button = null

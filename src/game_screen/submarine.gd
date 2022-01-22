extends KinematicBody2D
class_name Submarine

signal special_pressed(sender)

export(float) var base_up_speed = 50.0
export(float) var base_down_speed = 50.0
export(Vector2) var direction = Vector2.ZERO

onready var _effect_player: AnimationPlayer = $"EffectPlayer"
onready var _movement_sound_player: AudioStreamPlayer = $"MovementSoundPlayer"

var _current_button: ActionButton
var _up_speed = base_up_speed
var _down_speed = base_down_speed

func _process(delta: float) -> void:
	if not Input.is_action_pressed("interact"):
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

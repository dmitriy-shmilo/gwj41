extends KinematicBody2D
class_name Submarine

export(float) var up_speed = 50.0
export(float) var down_speed = 50.0
export(Vector2) var direction = Vector2.ZERO

onready var _effect_player: AnimationPlayer = $"EffectPlayer"

var _current_button: ActionButton

func _process(delta: float) -> void:
	if not Input.is_action_pressed("interact"):
		return
	
	if _current_button == null:
		return
		
	if direction == Vector2.ZERO:
		return

	if direction == Vector2.UP:
		move_and_slide(direction * up_speed)
		return
	
	if direction == Vector2.DOWN:
		move_and_slide(direction * down_speed)


func start_blinking() -> void:
	_effect_player.play("blink")


func stop_blinking() -> void:
	_effect_player.play("RESET")


func ascend() -> void:
	direction = Vector2.UP


func descend() -> void:
	direction = Vector2.DOWN


func go_steady() -> void:
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

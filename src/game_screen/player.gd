extends KinematicBody2D
class_name Player

export(float) var speed = 120.0

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"
onready var _animation_tree: AnimationTree = $"AnimationTree"
onready var _animation_state: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")

func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	direction = direction.normalized()

	if direction == Vector2.ZERO:
		_animation_state.travel("idle")
		return
	
	_animation_tree.set("parameters/walk/blend_position", direction)
	_animation_tree.set("parameters/idle/blend_position", direction)
	_animation_state.travel("walk")

	move_and_slide(direction * speed)


func operate() -> void:
	_animation_player.play()

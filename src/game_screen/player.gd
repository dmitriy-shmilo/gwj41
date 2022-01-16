extends KinematicBody2D
class_name Player

export(float) var speed = 120.0

func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	direction = direction.normalized()
	if direction == Vector2.ZERO:
		# idle
		return

	move_and_slide(direction * speed)

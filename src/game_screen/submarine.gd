extends KinematicBody2D
class_name Submarine

export(float) var speed = 60.0
export(Vector2) var direction = Vector2.ZERO

func _process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return

	direction = direction.normalized()

	move_and_slide(direction * speed)


func ascend() -> void:
	direction = Vector2.UP


func descend() -> void:
	direction = Vector2.DOWN


func go_steady() -> void:
	direction = Vector2.ZERO


func _on_Button1_pressed(sender) -> void:
	ascend()


func _on_Button2_pressed(sender) -> void:
	descend()


func _on_Button3_pressed(sender) -> void:
	pass # Replace with function body.


func _on_Button_released(sender) -> void:
	go_steady()

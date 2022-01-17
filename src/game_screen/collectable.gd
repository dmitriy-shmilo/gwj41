extends Node2D
class_name Collectable

const DISAPPEAR_AT_X = -100.0

signal collected(sender)

export(Vector2) var velocity


func _process(delta: float) -> void:
	global_position += velocity * delta
	
	if global_position.x <= DISAPPEAR_AT_X:
		queue_free()


func disappear() -> void:
	queue_free()

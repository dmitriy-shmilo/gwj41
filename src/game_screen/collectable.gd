extends Node2D
class_name Collectable

const DEFAULT_VELOCITY_X = -50.0
const DISAPPEAR_AT_X = -100.0

signal collected(sender)

export(Vector2) var velocity


func _ready() -> void:
	velocity = Vector2(DEFAULT_VELOCITY_X, 0.0)


func _process(delta: float) -> void:
	global_position += velocity * delta
	
	if global_position.x <= DISAPPEAR_AT_X:
		queue_free()


func disappear() -> void:
	queue_free()

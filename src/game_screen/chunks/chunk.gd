extends Node2D
class_name Chunk

const DISAPPEAR_AT_X = -100.0

signal end_visible(sender)

export(Vector2) var velocity

onready var _end = $"End"

func _process(delta: float) -> void:
	global_position += velocity * delta
	
	if _end.global_position.x <= DISAPPEAR_AT_X:
		queue_free()


func disappear() -> void:
	queue_free()


func _on_End_screen_entered() -> void:
	emit_signal("end_visible", self)

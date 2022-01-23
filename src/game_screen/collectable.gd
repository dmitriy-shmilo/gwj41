extends Node2D
class_name Collectable

const DISAPPEAR_AT_X = -100.0

signal collected(sender)

export(Vector2) var velocity



func disappear() -> void:
	queue_free()

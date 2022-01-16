extends Node2D
class_name Treasure

signal collected(sender)

export(int) var value = 1 
export(Vector2) var velocity


func _ready() -> void:
	velocity = Vector2(-50.0, 0.0)


func _process(delta: float) -> void:
	global_position += velocity * delta
	
	if global_position.x <= -100.0:
		queue_free()


func disappear() -> void:
	queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	if not body is Submarine:
		return
	
	emit_signal("collected", self)

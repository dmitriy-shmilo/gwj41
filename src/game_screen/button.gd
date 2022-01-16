extends Node2D


signal pressed(sender)
signal released(sender)


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		emit_signal("pressed", self)


func _on_Area2D_body_exited(body: Node) -> void:
	if body is Player:
		emit_signal("released", self)

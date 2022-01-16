extends Collectable
class_name Treasure

export(int) var value = 1 


func _on_Area2D_body_entered(body: Node) -> void:
	if not body is Submarine:
		return
	
	emit_signal("collected", self)

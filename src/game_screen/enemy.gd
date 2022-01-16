extends Collectable
class_name Enemy


func _on_CollisionArea_body_entered(body: Node) -> void:
	if not body is Submarine:
		return
	emit_signal("collected", self)

extends Collectable
class_name Enemy


func _on_CollisionArea_body_entered(body: Node) -> void:
	emit_signal("collected", self)

extends Collectable
class_name Treasure

export(int) var value = 1 

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"

func _process(delta: float) -> void:
	if _animation_player.is_playing() or randi() % 60 != 0:
		return
	
	_animation_player.play("shine")


func _on_Area2D_body_entered(body: Node) -> void:
	if not body is Submarine:
		return
	
	emit_signal("collected", self)

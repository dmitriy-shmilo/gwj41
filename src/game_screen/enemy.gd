extends Collectable
class_name Enemy

onready var _sprite: AnimatedSprite = $"Sprite"

func _ready() -> void:
	_sprite.frame = randi() % _sprite.frames.get_frame_count("default")


func _on_CollisionArea_body_entered(body: Node) -> void:
	if not body is Submarine:
		return
	emit_signal("collected", self)
	if Settings.particles:
		$DeathParticles.emitting = true


func disappear() -> void:
	$CollisionArea.set_deferred("disabled", true)
	_sprite.visible = false

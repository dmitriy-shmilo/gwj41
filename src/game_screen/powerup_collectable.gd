extends Collectable
class_name PowerupCollectable

const POWERUPS = [
	preload("res://data/powerups/hp_up.tres"),
	preload("res://data/powerups/oxygen_up.tres"),
	preload("res://data/powerups/speed_down.tres"),
	preload("res://data/powerups/speed_up.tres"), 
	preload("res://data/powerups/vspeed_up.tres")
]

export(Resource) var powerup = POWERUPS[0]

onready var _animation_player: AnimationPlayer = $"AnimationPlayer"

func _ready() -> void:
	powerup = POWERUPS[randi() % POWERUPS.size()]


func _process(delta: float) -> void:
	if _animation_player.is_playing() or randi() % 60 != 0:
		return
	
	_animation_player.play("shine")


func _on_Area2D_body_entered(body: Node) -> void:
	if not body is Submarine:
		return
	
	emit_signal("collected", self)

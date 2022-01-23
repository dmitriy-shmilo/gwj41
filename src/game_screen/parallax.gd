extends ParallaxBackground
class_name Parallax

export(float) var speed = 0.0

func _process(delta: float) -> void:
	scroll_offset.x -= speed * delta

extends Node

const DEFAULT_STEPS = 5
const DEFAULT_DURATION = 0.5

onready var _tween = $"Tween"

func shake_horizontal(node: Node, property: NodePath, amplitude: float, steps: int = DEFAULT_STEPS, duration: float = DEFAULT_DURATION) -> void:
	var offset = pow(-1, randi() % 2) * Vector2.RIGHT * amplitude
	shake(node, property, offset, steps, duration)


func shake_vertical(node: Node, property: NodePath, amplitude: float, steps: int = DEFAULT_STEPS, duration: float = DEFAULT_DURATION) -> void:
	var offset = pow(-1, randi() % 2) * Vector2.UP * amplitude
	shake(node, property, offset, steps, duration)


func shake_random(node: Node, property: NodePath, amplitude: float, steps: int = DEFAULT_STEPS, duration: float = DEFAULT_DURATION) -> void:
	var offset = polar2cartesian(amplitude, randf() * PI * 2)
	shake(node, property, offset, steps, duration)


func shake(node: Node, property: NodePath, forward_offset: Vector2, steps: int = DEFAULT_STEPS, duration: float = DEFAULT_DURATION) -> void:
	_tween.reset_all()
	_tween.stop_all()
	
	var step_duration = duration / steps
	var marginal_step_duration = step_duration / 2
	var backward_offset = -forward_offset
	var start = node.get(property)
	
	var from = start
	var to = start + forward_offset
	var delay = 0
	
	_tween.interpolate_property(node, property,
		 from, to,
		 marginal_step_duration, 
		Tween.TRANS_LINEAR, Tween.EASE_OUT, 
		0)
	delay += marginal_step_duration
	
	for step in range(1, steps - 1):
		from = to
		to = start + (backward_offset - backward_offset / steps * (step + 1))
		_tween.interpolate_property(node, property,
			from, to,
			step_duration, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT, 
			delay)
		delay += step_duration
		
		from = to
		to = start + (forward_offset - forward_offset / steps * (step + 1))
		_tween.interpolate_property(node, property,
			from, to,
			step_duration, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT, 
			delay)
		delay += step_duration

	from = to
	to = start
	_tween.interpolate_property(node, property,
		from, to,
		marginal_step_duration, 
		Tween.TRANS_LINEAR, Tween.EASE_OUT, 
		delay)
	_tween.start()


func shake_chaotic(node: Node, property: NodePath, amplitude: float, steps: int = DEFAULT_STEPS, duration: float = DEFAULT_DURATION) -> void:
	_tween.reset_all()
	_tween.stop_all()
	
	var step_duration = duration / steps
	var marginal_step_duration = step_duration / 2
	var forward_offset = polar2cartesian(amplitude, randf() * PI * 2)
	var backward_offset = -forward_offset
	var start = node.get(property)
	
	var from = start
	var to = start + forward_offset
	var delay = 0
	
	for step in range(1, steps):
		from = to
		to = start + polar2cartesian(amplitude - amplitude * step / steps, randf() * PI * 2)
		_tween.interpolate_property(node, property,
			from, to,
			marginal_step_duration, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT, 
			delay)
		delay += marginal_step_duration
		
		from = to
		to = start
		_tween.interpolate_property(node, property,
			from, to,
			marginal_step_duration, 
			Tween.TRANS_LINEAR, Tween.EASE_OUT, 
			delay)
		delay += marginal_step_duration
	_tween.start()

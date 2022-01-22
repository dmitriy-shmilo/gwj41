extends Node
class_name Gui

const LIFE_ICON_SCENE = preload("res://game_screen/life_icon.tscn")

onready var _distance_label: Label = $"DistanceLabel"
onready var _oxygen_progress: TextureProgress = $"OxygenBackground/OxygenProgress"
onready var _treasure_label: Label = $"TreasureLabel"
onready var _lives_container: HBoxContainer = $"LivesContainer"
onready var _run_title_label: Label = $"RunTitleLabel"
onready var _run_title_tween: Tween = $"RunTitleTween"
onready var _powerup_label: Label = $"PowerupLabel"
onready var _oxygen_effect_player: AnimationPlayer = $"OxygenBackground/OxygenProgress/EffectPlayer"

func show_run_title(text: String) -> void:
	var height = _run_title_label.rect_size.y
	var start_y = get_viewport().size.y + height
	var mid_y = get_viewport().size.y / 2 - height / 2
	var end_y = -height
	var start_opacity = 0.0
	var mid_opacity = 0.75
	var end_opacity = 0.0
	
	_run_title_label.text = text
	_run_title_tween.stop_all()
	
	# fade in
	_run_title_tween.interpolate_property(_run_title_label, "rect_position", Vector2(0, start_y), Vector2(0, mid_y), 0.66, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_run_title_tween.interpolate_property(_run_title_label, "modulate:a", start_opacity, mid_opacity, 0.66, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	# fade out
	_run_title_tween.interpolate_property(_run_title_label, "rect_position", Vector2(0, mid_y), Vector2(0, end_y), 0.66, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.5)
	_run_title_tween.interpolate_property(_run_title_label, "modulate:a", mid_opacity, end_opacity, 0.66, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.5)
	_run_title_tween.start()
	
func update_score(current: int) -> void:
	var text = "x000"
	
	if current < 1000:
		text = "x%03d" % current
	elif current < 1000000:
		text = "x%0.1fK" % (float(current) / 1000.0)
	else:
		text = "x%0.1fM" % (float(current) / 1000000.0)

	_treasure_label.text = text


func update_lives(current: int, total: int) -> void:
	if current < 0 or total < 0:
		return

	var life_icons = _lives_container.get_children()
	if life_icons.size() < total:
		for i in range(total - life_icons.size()):
			_lives_container.add_child(LIFE_ICON_SCENE.instance())
	elif life_icons.size() > total:
		for i in range(life_icons.size() - total):
			life_icons[i].queue_free()
		life_icons.resize(total)
	
	for i in range(total):
		var node = _lives_container.get_child(total - i - 1)
		node.is_full = i < current


func update_distance(distance: float) -> void:
	_distance_label.text = tr("txt_current_distance") % int(distance)


func update_oxygen(current: float, total: float) -> void:
	_oxygen_progress.max_value = total
	_oxygen_progress.value = current
	
	if current / total > 0.25:
		_oxygen_effect_player.play("RESET")
	else:
		_oxygen_effect_player.play("blink")


func update_powerup(powerup: Powerup) -> void:
	if powerup == null:
		_powerup_label.text = ""
		return
	
	_powerup_label.text = tr(powerup.title)

extends Node
class_name Fader

const AUDIO_OUT_VOLUME = -16.0
const AUDIO_IN_VOLUME = 0.0

signal fade_in_completed
signal fade_out_completed

export(float) var fade_in_duration = 0.3
export(float) var fade_out_duration = 0.3
export(bool) var fade_in_when_ready = true
export(NodePath) var audio_player

onready var _tween: Tween = $"Tween"
onready var _fade: ColorRect = $"Fade"

var _out_color: Color
var _in_color: Color
var _audio_player: AudioStreamPlayer

func _ready() -> void:
	if audio_player != "":
		_audio_player = get_node(audio_player)
	_fade.visible = true
	_out_color = _fade.modulate
	_in_color = Color(_out_color.r, _out_color.g, _out_color.b, 0)
	if fade_in_when_ready:
		fade_in()


func fade_in() -> void:
	var _res = _tween.stop_all()
	_res = _tween.interpolate_property(_fade, "modulate",
		_out_color, _in_color, fade_in_duration,
		 Tween.TRANS_LINEAR, Tween.EASE_IN)
	if _audio_player != null:
		_res = _tween.interpolate_property(_audio_player, "volume_db",
			AUDIO_OUT_VOLUME, AUDIO_IN_VOLUME, fade_in_duration,
			 Tween.TRANS_LINEAR, Tween.EASE_IN)
	_res = _tween.start()
	yield(_tween, "tween_all_completed")
	emit_signal("fade_in_completed")


func fade_out() -> void:
	var _res = _tween.stop_all()
	_res = _tween.interpolate_property(_fade, "modulate",
		_fade.modulate, _out_color, fade_out_duration,
		 Tween.TRANS_LINEAR,Tween.EASE_IN)
	if _audio_player != null:
		_res = _tween.interpolate_property(_audio_player, "volume_db",
			AUDIO_IN_VOLUME, AUDIO_OUT_VOLUME, fade_in_duration,
			 Tween.TRANS_LINEAR, Tween.EASE_IN)
	_res = _tween.start()
	yield(_tween, "tween_all_completed")
	emit_signal("fade_out_completed")

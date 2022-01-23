extends VBoxContainer


onready var _fader: Fader = $"Fader"
onready var _message_label: Label = $"PanelContainer/Control/MessageLabel"

func _ready() -> void:
	_message_label.text = tr("ui_win_message") % UserSaveData.current_expedition


func _on_QuitButton_pressed():
	_fader.fade_out()
	yield(_fader, "fade_out_completed")
	get_tree().change_scene("res://title_screen/title_screen.tscn")


func _on_RetryButton_pressed():
	get_tree().change_scene("res://game_screen/game_screen.tscn")

extends Control
class_name TitleScene

onready var _quit_button = $"QuitButton"
onready var _new_game_button = $"NewGameButton"

func _ready():
	_quit_button.visible = not OS.has_feature("HTML5")
	_new_game_button.text = tr("ui_start_game") if UserSaveData.current_expedition <= 0 else tr("ui_continue")


func _on_TitleScene_visibility_changed() -> void:
	if visible:
		_new_game_button.grab_focus()

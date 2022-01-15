extends Control

onready var _fader = $"Fader"
onready var _title_scene: Control = $"TitleScene"
onready var _credits_scene: Control = $"CreditsScene"
onready var _settings_scene: Control = $"SettingsScene"
onready var _tutorial_scene: Control = $"TutorialScene"
onready var _scenes = [
	_title_scene, _credits_scene, 
	_settings_scene, _tutorial_scene
]

var _transition_target: Control = null

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_BackToTitleButton_pressed() -> void:
	_transition_to(_title_scene)


func _on_CreditsButton_pressed():
	_transition_to(_credits_scene)


func _on_TutorialButton_pressed():
	_transition_to(_tutorial_scene)


func _on_SettingsButton_pressed():
	_transition_to(_settings_scene)


func _on_NewGameButton_pressed():
	_fader.fade_out()
	yield(_fader, "fade_out_completed")
	var err = get_tree().change_scene("res://game_screen/game_screen.tscn")
	ErrorHandler.handle(err)


func _transition_to(scene: Control) -> void:
	if _transition_target != null:
		return

	_transition_target = scene
	_fader.fade_out()
	yield(_fader, "fade_out_completed")

	for scene in _scenes:
		scene.visible = false
	scene.visible = true

	_transition_target = null
	_fader.fade_in()

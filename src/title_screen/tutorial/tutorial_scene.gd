extends Control
class_name TutorialScene

onready var _slides = [
	$"PanelContainer/Slide1",
	$"PanelContainer/Slide2",
	$"PanelContainer/Slide3",
	$"PanelContainer/Slide4",
	$"PanelContainer/Slide5",
	$"PanelContainer/Slide6",
	$"PanelContainer/Slide7"
]

var _current_slide = 0

func _ready() -> void:
	var up = InputMap.get_action_list("ui_up")[0].as_text()
	var down = InputMap.get_action_list("ui_down")[0].as_text()
	var left = InputMap.get_action_list("ui_left")[0].as_text()
	var right = InputMap.get_action_list("ui_right")[0].as_text()
	var interact = InputMap.get_action_list("ui_accept")[0].as_text()
	
	$PanelContainer/Slide1/Label.text = tr("ui_tutorial_1") % [up, down, left, right, interact]

func _refresh() -> void:
	for slide in _slides:
		slide.visible = false

	_slides[_current_slide].visible = true

func _on_VBoxContainer_visibility_changed() -> void:
	if visible:
		$Controls/BackToTitleButton.grab_focus()


func _on_PrevButton_pressed() -> void:
	_current_slide = max(0, _current_slide - 1)
	_refresh()


func _on_NextButton_pressed() -> void:
	_current_slide = min(_slides.size() - 1, _current_slide + 1)
	_refresh()

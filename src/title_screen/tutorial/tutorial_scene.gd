extends Control
class_name TutorialScene


func _on_VBoxContainer_visibility_changed() -> void:
	if visible:
		$BackToTitleButton.grab_focus()

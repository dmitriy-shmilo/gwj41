extends Control
class_name CreditsScene


func _ready() -> void:
	$CreditsText.bbcode_text = tr("txt_credits")


func _on_CreditsText_meta_clicked(meta):
	var err = OS.shell_open(meta)
	ErrorHandler.handle(err)


func _on_CreditsScreen_visibility_changed() -> void:
	if visible:
		$BackToTitleButton.grab_focus()

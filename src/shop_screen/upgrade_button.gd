extends AspectRatioContainer

signal selected(sender, upgrade)

onready var _button = $"Button"

var _upgrade: Upgrade


func setup(upgrade: Upgrade) -> void:
	_upgrade = upgrade


func _on_Button_mouse_entered() -> void:
	_button.grab_focus()


func _on_Button_focus_entered() -> void:
	emit_signal("selected", self, _upgrade)

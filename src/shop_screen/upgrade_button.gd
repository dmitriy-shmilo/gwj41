extends AspectRatioContainer

signal selected(sender, upgrade)
signal purchased(sender, upgrade)

onready var _button: Button = $"Button"
onready var _checkmark_icon = $"Button/CheckmarkIcon"

var _upgrade: Upgrade

func _ready() -> void:
	refresh()


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action("interact"):
		_purchase_upgrade()


func setup(upgrade: Upgrade) -> void:
	_upgrade = upgrade
	if is_inside_tree():
		refresh()


func refresh() -> void:
	_checkmark_icon.visible = _upgrade.purchased
	_button.disabled = _upgrade.price > UserSaveData.current_treasure or _upgrade.required_progress > UserSaveData.best_progress


func _purchase_upgrade() -> void:
	if _upgrade.purchased or UserSaveData.best_progress < _upgrade.required_progress:
		return

	if UserSaveData.current_treasure >= _upgrade.price:
		_upgrade.purchased = true
		UserSaveData.unlocked_upgrades.append(_upgrade.id)
		UserSaveData.current_treasure -= _upgrade.price
		emit_signal("purchased", self, _upgrade)
		refresh()


func _on_Button_mouse_entered() -> void:
	_button.grab_focus()


func _on_Button_focus_entered() -> void:
	emit_signal("selected", self, _upgrade)


func _on_Button_pressed() -> void:
	_purchase_upgrade()

extends Node2D
class_name ActionButton

signal targeted(sender)
signal untargeted(sender)

export(Resource) var action

onready var _hint_label = $"HintLabel"


func _ready() -> void:
	var key = InputMap.get_action_list("ui_accept")[0].as_text()
	_hint_label.text = tr(action.hint) % key


func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		emit_signal("targeted", self)


func _on_Area2D_body_exited(body: Node) -> void:
	if body is Player:
		emit_signal("untargeted", self)


func toggle_hint(visible: bool) -> void:
	_hint_label.visible = visible

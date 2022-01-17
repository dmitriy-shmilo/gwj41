extends PanelContainer

signal upgrade_selected(sender, upgrade)

const UPGRADE_BUTTON_SCENE = preload("res://shop_screen/upgrade_button.tscn")

onready var _milestone_label = $"VBoxContainer/MilestoneLabel"
onready var _grid_container = $"VBoxContainer/GridContainer"

var _milestone = 0
var _upgrades = []

func _ready() -> void:
	_milestone_label.text = tr("txt_milestone") % _milestone
	
	for upgrade in _upgrades:
		var button = UPGRADE_BUTTON_SCENE.instance()
		button.setup(upgrade)
		button.connect("selected", self, "_on_button_selected")
		_grid_container.add_child(button)


func setup(milestone: int, upgrades: Array) -> void:
	_milestone = milestone
	_upgrades = upgrades


func _on_button_selected(sender, upgrade) -> void:
	emit_signal("upgrade_selected", sender, upgrade)

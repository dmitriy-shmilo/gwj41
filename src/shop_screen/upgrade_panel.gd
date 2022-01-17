extends PanelContainer

signal upgrade_selected(sender, upgrade)
signal upgrade_purchased(sender, upgrade)

const UPGRADE_BUTTON_SCENE = preload("res://shop_screen/upgrade_button.tscn")

onready var _milestone_label = $"VBoxContainer/MilestoneLabel"
onready var _grid_container = $"VBoxContainer/GridContainer"

var _milestone = 0
var _upgrades = []

func _ready() -> void:
	_milestone_label.text = tr("txt_milestone") % _milestone
	if UserSaveData.best_progress < _milestone:
		_milestone_label.set("custom_colors/font_color", Color.salmon)
	
	for upgrade in _upgrades:
		var button = UPGRADE_BUTTON_SCENE.instance()
		button.setup(upgrade)
		button.connect("selected", self, "_on_button_selected")
		button.connect("purchased", self, "_on_upgrade_purchased")
		_grid_container.add_child(button)


func refresh() -> void:
	for button in _grid_container.get_children():
		button.refresh()


func setup(milestone: int, upgrades: Array) -> void:
	_milestone = milestone
	_upgrades = upgrades


func _on_button_selected(sender, upgrade) -> void:
	emit_signal("upgrade_selected", sender, upgrade)


func _on_upgrade_purchased(sender, upgrade) -> void:
	emit_signal("upgrade_purchased", sender, upgrade)

extends Control

const UPGRADE_PANEL_SCENE = preload("res://shop_screen/upgrade_panel.tscn")

onready var _current_treasure_label = $"CurrentTreasureLabel"
onready var _upgrade_list = $"ScrollContainer/UpgradeList"
onready var _sidebar_container = $"SideBarContainer"
onready var _upgrade_name_label = $"SideBarContainer/VBoxContainer/UpgradeNameLabel"
onready var _upgrade_price_label = $"SideBarContainer/VBoxContainer/UpgradePriceLabel"
onready var _upgrade_description_label = $"SideBarContainer/VBoxContainer/UpgradeDescriptionLabel"

func _ready() -> void:
	_current_treasure_label.bbcode_text = tr("txt_treasure_count_right") % UserSaveData.current_treasure
	
	var milestones = UpgradeRegistry.get_progress_milestones()
	
	for milestone in milestones:
		var panel = UPGRADE_PANEL_SCENE.instance()
		panel.setup(milestone, UpgradeRegistry.get_milestone_upgrades(milestone))
		panel.connect("upgrade_selected", self, "_on_upgrade_selected")
		_upgrade_list.add_child(panel)


func _on_upgrade_selected(sender, upgrade: Upgrade) -> void:
	_sidebar_container.visible = true
	_upgrade_name_label.text = tr(upgrade.title)
	_upgrade_description_label.text = tr(upgrade.description)
	_upgrade_price_label.bbcode_text = tr("txt_treasure_count_right") % upgrade.price


func _on_NewRunButton_pressed() -> void:
	UserSaveData.is_running = false
	UserSaveData.save_data()
	get_tree().change_scene("res://game_screen/game_screen.tscn")

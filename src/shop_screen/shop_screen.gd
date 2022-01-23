extends Control

const UPGRADE_PANEL_SCENE = preload("res://shop_screen/upgrade_panel.tscn")

onready var _current_treasure_label = $"CurrentTreasureLabel"
onready var _upgrade_list = $"ScrollContainer/UpgradeList"
onready var _sidebar_container = $"SideBarContainer"
onready var _upgrade_name_label = $"SideBarContainer/VBoxContainer/UpgradeNameLabel"
onready var _upgrade_price_label = $"SideBarContainer/VBoxContainer/UpgradePriceLabel"
onready var _upgrade_description_label = $"SideBarContainer/VBoxContainer/UpgradeDescriptionLabel"
onready var _soundtrack_player: AudioStreamPlayer = $"SoundtrackPlayer"
onready var _fader: Fader = $"Fader"

func _ready() -> void:
	$NewRunButton.grab_focus()
	_soundtrack_player.seek(UserSaveData.menu_soundtrack_time)
	_refresh()
	
	var milestones = UpgradeRegistry.get_progress_milestones()
	
	for milestone in milestones:
		var panel = UPGRADE_PANEL_SCENE.instance()
		panel.setup(milestone, UpgradeRegistry.get_milestone_upgrades(milestone))
		panel.connect("upgrade_selected", self, "_on_upgrade_selected")
		panel.connect("upgrade_purchased", self, "_on_upgrade_purchased")
		_upgrade_list.add_child(panel)


func _on_upgrade_selected(sender, upgrade: Upgrade) -> void:
	_sidebar_container.visible = true
	_upgrade_name_label.text = tr(upgrade.title)
	_upgrade_description_label.text = tr(upgrade.description)
	
	if upgrade.purchased:
		_upgrade_price_label.bbcode_text = tr("txt_up_purchased")
	else:
		var price = tr("txt_treasure_count_right") % upgrade.price
		if upgrade.price > UserSaveData.current_treasure:
			_upgrade_price_label.clear()
			# TODO: pick a better color
			_upgrade_price_label.push_color(Color.salmon)
			_upgrade_price_label.append_bbcode(price)
			_upgrade_price_label.pop()
		else:
			_upgrade_price_label.bbcode_text = price


func _on_upgrade_purchased(sender, upgrade: Upgrade) -> void:
	if upgrade.id == preload("res://data/upgrades/finish.tres").id:
		_fader.fade_out()
		UserSaveData.menu_soundtrack_time = _soundtrack_player.get_playback_position()
		UserSaveData.is_running = false
		yield(_fader, "fade_out_completed")
		UserSaveData.save_data()
		get_tree().change_scene("res://game_over_screen/game_over_screen.tscn")
	_refresh()
	# this will refresh the sidebar
	_on_upgrade_selected(sender, upgrade)


func _refresh() -> void:
	_current_treasure_label.bbcode_text = tr("txt_treasure_count_right") % UserSaveData.current_treasure
	
	for panel in _upgrade_list.get_children():
		panel.refresh()


func _on_NewRunButton_pressed() -> void:
	_fader.fade_out()
	UserSaveData.menu_soundtrack_time = _soundtrack_player.get_playback_position()
	UserSaveData.is_running = false
	yield(_fader, "fade_out_completed")
	UserSaveData.save_data()
	get_tree().change_scene("res://game_screen/game_screen.tscn")

extends Control
class_name ScoreScreen


onready var _score_label = $"ScoreLabel"
onready var _current_treasure = $"CurrentTreasure"
onready var _gained_treasure = $"GainedTreasure"
onready var _total_treasure = $"TotalTreasure"
onready var _new_upgrades_indicator = $"ShopButton/NewUpgradesIndicator"
onready var _new_upgrades_tween = $"ShopButton/NewUpgradesTween"

func _ready() -> void:
	_score_label.bbcode_text = tr("txt_score_title") % UserSaveData.current_expedition
	_current_treasure.bbcode_text = tr("txt_treasure_count") % UserSaveData.current_treasure
	_gained_treasure.bbcode_text = tr("txt_treasure_count_plus") % UserSaveData.last_recovered_treasure
	_total_treasure.bbcode_text = tr("txt_treasure_count") % (UserSaveData.current_treasure + UserSaveData.last_recovered_treasure)
	UserSaveData.current_treasure += UserSaveData.last_recovered_treasure
	UserSaveData.save_data()
	
	_new_upgrades_indicator.visible = UpgradeRegistry.purchasable_upgrades_available()
	_new_upgrades_tween.interpolate_property(_new_upgrades_indicator, "rec_scale", Vector2.ONE, Vector2(1.5, 1.5), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	_new_upgrades_tween.interpolate_property(_new_upgrades_indicator, "rect_scale", Vector2(1.5, 1.5), Vector2.ONE, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.4)
	_new_upgrades_tween.start()


func _on_QuitButton_pressed() -> void:
	get_tree().change_scene("res://title_screen/title_screen.tscn")


func _on_NewRunButton_pressed() -> void:
	get_tree().change_scene("res://game_screen/game_screen.tscn")


func _on_ShopButton_pressed() -> void:
	get_tree().change_scene("res://shop_screen/shop_screen.tscn")

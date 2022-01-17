extends Control
class_name ScoreScreen


onready var _score_label = $"ScoreLabel"
onready var _current_treasure = $"CurrentTreasure"
onready var _gained_treasure = $"GainedTreasure"
onready var _total_treasure = $"TotalTreasure"


func _ready() -> void:
	_score_label.bbcode_text = tr("txt_score_title") % UserSaveData.current_expedition
	_current_treasure.bbcode_text = tr("txt_treasure_count") % UserSaveData.current_treasure
	_gained_treasure.bbcode_text = tr("txt_treasure_count_plus") % UserSaveData.last_recovered_treasure
	_total_treasure.bbcode_text = tr("txt_treasure_count") % (UserSaveData.current_treasure + UserSaveData.last_recovered_treasure)
	UserSaveData.current_treasure += UserSaveData.last_recovered_treasure
	UserSaveData.save_data()


func _on_QuitButton_pressed() -> void:
	get_tree().change_scene("res://title_screen/title_screen.tscn")


func _on_NewRunButton_pressed() -> void:
	get_tree().change_scene("res://game_screen/game_screen.tscn")


func _on_ShopButton_pressed() -> void:
	get_tree().change_scene("res://shop_screen/shop_screen.tscn")

extends Control


onready var _current_treasure_label = $"CurrentTreasureLabel"


func _ready() -> void:
	_current_treasure_label.bbcode_text = tr("txt_treasure_count_right") % UserSaveData.current_treasure


func _on_NewRunButton_pressed() -> void:
	UserSaveData.is_running = false
	UserSaveData.save_data()
	get_tree().change_scene("res://game_screen/game_screen.tscn")

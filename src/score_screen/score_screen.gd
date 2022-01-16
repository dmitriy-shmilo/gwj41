extends Control
class_name ScoreScreen


func _on_QuitButton_pressed() -> void:
	get_tree().change_scene("res://title_screen/title_screen.tscn")


func _on_NewRunButton_pressed() -> void:
	get_tree().change_scene("res://game_screen/game_screen.tscn")


func _on_ShopButton_pressed() -> void:
	get_tree().change_scene("res://shop_screen/shop_screen.tscn")

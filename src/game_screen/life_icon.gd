extends TextureRect

const FULL_LIFE_TEXTURE = preload("res://assets/art/full_life_icon.tres")
const EMPTY_LIFE_TEXTURE = preload("res://assets/art/empty_life_icon.tres")

var is_full setget set_is_full

func _ready() -> void:
	texture = FULL_LIFE_TEXTURE if is_full else EMPTY_LIFE_TEXTURE


func set_is_full(value: bool) -> void:
	is_full = value
	texture = FULL_LIFE_TEXTURE if value else EMPTY_LIFE_TEXTURE

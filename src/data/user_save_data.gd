extends Node

const SAVE_FILE = "user://save.json"

var current_expedition = 0
var current_treasure = 0
var last_recovered_treasure = 0
var best_progress = 0
var unlocked_upgrades = []
var is_running = true
var _save_time = 0


func _ready() -> void:
	load_data()


func save_data() -> void:
	_save_time = OS.get_unix_time()

	var file = File.new()
	var err = file.open(SAVE_FILE, File.WRITE)
	ErrorHandler.handle(err)
	file.store_string(to_json(_get_data()))
	file.close()


func load_data() -> void:
	var file := File.new()

	if not file.file_exists(SAVE_FILE):
		save_data()
		return

	var open_err = file.open(SAVE_FILE, File.READ)
	ErrorHandler.handle(open_err)

	var data := JSON.parse(file.get_as_text())
	
	if data.error != OK:
		ErrorHandler.handle(data.error)
		save_data()
		return

	_set_from_data(data.result)


func _get_data() -> Dictionary:
	return {
		"_save_time" : _save_time,
		"current_expedition" : current_expedition,
		"current_treasure" : current_treasure,
		"last_recovered_treasure" : last_recovered_treasure,
		"unlocked_upgrades" : unlocked_upgrades,
		"is_running" : is_running,
		"best_progress" : best_progress
	}


func _set_from_data(data: Dictionary) -> void:
	_save_time = _get_or_default(data, "_save_time", 0)
	current_expedition = _get_or_default(data, "current_expedition", 0)
	current_treasure = _get_or_default(data, "current_treasure", 0)
	last_recovered_treasure = _get_or_default(data, "last_recovered_treasure", 0)
	unlocked_upgrades = _get_or_default(data, "unlocked_upgrades", [])
	is_running = _get_or_default(data, "is_running", true)
	best_progress = _get_or_default(data, "best_progress", 0)


func _get_or_default(data: Dictionary, key: String, default) -> Object:
	if data.has(key):
		return data[key]
	return default



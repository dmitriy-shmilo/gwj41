extends Node


const UPGRADES = [
	preload("res://data/upgrades/health1.tres"),
	preload("res://data/upgrades/health2.tres"),
	preload("res://data/upgrades/health3.tres"),
	preload("res://data/upgrades/oxygen1.tres"),
	preload("res://data/upgrades/oxygen2.tres"),
	preload("res://data/upgrades/oxygen3.tres")
]

var _milestone_map = {}

func _ready() -> void:
	_load()


func get_progress_milestones() -> Array:
	var result = _milestone_map.keys().duplicate()
	result.sort()
	return result


func get_purchased_upgrades() -> Array:
	var result = []
	
	for upgrade in UPGRADES:
		if UserSaveData.unlocked_upgrades.has(float(upgrade.id)):
			result.append(upgrade)

	return result


func get_milestone_upgrades(milestone: int) -> Array:
	return _milestone_map[milestone]


func _load() -> void:
	for upgrade in UPGRADES:
		if not _milestone_map.has(upgrade.required_progress):
			_milestone_map[upgrade.required_progress] = []
		upgrade.purchased = UserSaveData.unlocked_upgrades.has(float(upgrade.id))
		_milestone_map[upgrade.required_progress].append(upgrade)
	
	for key in _milestone_map.keys():
		_milestone_map[key].sort_custom(self, "_upgrade_id_sort")


func _upgrade_id_sort(a: Upgrade, b: Upgrade) -> bool:
	return b.id > a.id

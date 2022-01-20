extends Resource
class_name Upgrade

enum Type {
	unknown = 0
	health = 1,
	oxygen = 2,
	ascend_speed = 3,
	descend_speed = 4
}

export(int) var id = -1
export(int) var price = 1
export(int) var required_progress = 50
export(int) var strength = 0
export(Type) var type = 0
export(String) var title = "txt_upgrade_title"
export(String) var description = "txt_upgrade_description"
export(Texture) var icon
export(bool) var purchased = false

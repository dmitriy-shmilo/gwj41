extends Resource
class_name Powerup

enum Type {
	unknown = 0,
	hspeed = 1,
	oxygen = 2,
	health = 3,
	vspeed = 4
}

export(Type) var type = 0
export(String) var title = "txt_power_unknown"
export(float) var strength = 0.0
export(Texture) var icon

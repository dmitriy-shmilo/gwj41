extends Resource
class_name ButtonAction

enum Type {
	unknown = 0,
	ascend = 1,
	descend = 2,
	special = 3
}

export(String) var title = "txt_action_unknown"
export(String) var hint = "txt_action_hint_unknown"
export(int) var type = 0

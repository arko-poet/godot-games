class_name Resources extends Object

enum Type {
	COAL
}

static func get_type_name(type: Type) -> String:
	return Type.find_key(type)

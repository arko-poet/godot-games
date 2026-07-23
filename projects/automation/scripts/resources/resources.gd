class_name Resources extends Object

enum Type {
	COAL,
	COPPER,
	SILVER,
	COPPER_BAR,
	SILVER_BAR
}

static func get_type_name(type: Type) -> String:
	return Type.find_key(type)


static func _get_random_ore() -> Type:
	return Resources.Type.values()[randi() % 3]

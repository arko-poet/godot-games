class_name Resources extends Object

const NUMBER_OF_ORES := 3

enum Type {
	COAL,
	COPPER,
	SILVER,
	COPPER_BAR,
	SILVER_BAR,
	COPPER_WIRE,
	SILVER_PLATE,
	AUTOMATRON
}

static func get_type_name(type: Type) -> String:
	return Type.find_key(type)


static func _get_random_ore() -> Type:
	return Resources.Type.values()[randi() % NUMBER_OF_ORES]

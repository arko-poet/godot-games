extends Item

@export_range(1, 100) var heal: int


func _get_active_effect() -> Dictionary:
	return {"heal": heal}

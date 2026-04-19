extends Item

@export_range(1, 100) var max_hp: int


func get_passive_effect() -> Dictionary:
	return {
		"max_hp": max_hp,
		"producer": self
	}


func _set_footprint() -> void:
	footprint = [Vector2.ZERO]

extends Item

@export_range(1, 100) var heal: int


func _get_active_effect() -> Dictionary:
	return {"heal": heal}


func _set_footprints() -> void:
	footprints.append([Vector2i.ZERO])


func _set_rotation_offsets() -> void:
	rotation_offsets.append(Vector2i.ZERO)

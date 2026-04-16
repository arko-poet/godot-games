extends Item

@export_range(1, 100) var max_hp: int


func get_passive_effect() -> Dictionary:
	var effect := {}
	effect["max_hp"] = max_hp
	effect["producer"] = self
	return effect


func _set_footprints() -> void:
	footprints.append([Vector2i.ZERO])
	footprints.append([Vector2i.ZERO])
	footprints.append([Vector2i.ZERO])
	footprints.append([Vector2i.ZERO])


func _set_rotation_offsets() -> void:
	rotation_offsets.append(Vector2i.ZERO)
	rotation_offsets.append(Vector2i(-16, 0))
	rotation_offsets.append(Vector2i(-16, -16))
	rotation_offsets.append(Vector2i(0, -16))

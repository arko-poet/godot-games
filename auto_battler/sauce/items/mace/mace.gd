extends Item

@export_range(1, 100) var attack_damage: int
@export_range(1, 100) var block_damage: int


func _get_active_effect() -> Dictionary:
	var effect := {}
	effect["attack_damage"] = attack_damage
	effect["block_damage"] = block_damage
	effect["producer"] = self
	return effect


func _set_footprints() -> void:
	footprints.append([Vector2i.ZERO, Vector2i(0, 1), Vector2i(0, 2)])
	footprints.append([Vector2i.ZERO, Vector2i(-1, 0), Vector2i(-2, 0)])
	footprints.append([Vector2i.ZERO, Vector2i(0, -1), Vector2i(0, -2)])
	footprints.append([Vector2i.ZERO, Vector2i(1, 0), Vector2i(2, 0)])


func _set_rotation_offsets() -> void:
	rotation_offsets.append(Vector2i.ZERO)
	rotation_offsets.append(Vector2i(-48, 0))
	rotation_offsets.append(Vector2i(-16, -48))
	rotation_offsets.append(Vector2i(0, -16))
	

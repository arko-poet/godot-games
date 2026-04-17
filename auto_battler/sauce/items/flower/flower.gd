extends Item

@export_range(1, 100) var heal: int


func _get_actions() -> Array[CombatAction]:
	return [CombatAction.new(CombatAction.Type.HEAL, heal, self)]


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

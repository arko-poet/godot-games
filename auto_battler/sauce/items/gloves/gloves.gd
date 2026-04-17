extends Item

@export_range(1, 100) var attack_damage: int
@export_range(1, 100) var break_damage: int


func _set_footprints() -> void:
	footprints.append([Vector2i.ZERO, Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)])
	footprints.append([Vector2i.ZERO, Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)])
	footprints.append([Vector2i.ZERO, Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)])
	footprints.append([Vector2i.ZERO, Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)])


func _set_rotation_offsets() -> void:
	rotation_offsets.append(Vector2i.ZERO)
	rotation_offsets.append(Vector2i(-32, 0))
	rotation_offsets.append(Vector2i(-32, -32))
	rotation_offsets.append(Vector2i(0, 32))
	

func _set_bonus_cells() -> void:
	bonus_cells.append(Vector2i(0, -1))
	bonus_cells.append(Vector2i(1, -1))
	bonus_cells.append(Vector2i(2, 0))
	bonus_cells.append(Vector2i(2, 1))
	bonus_cells.append(Vector2i(0, 2))
	bonus_cells.append(Vector2i(1, 2))
	bonus_cells.append(Vector2i(-1, 0))
	bonus_cells.append(Vector2i(-1, 1))


func _get_bonus() -> Dictionary:
	return {"cooldown": 0.4}

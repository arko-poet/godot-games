extends Item

@export_range(1, 100) var attack_damage: int
@export_range(1, 100) var block_damage: int
## TODO add armour breaking

func _get_active_effect() -> Dictionary:
	return {"attack_damage": attack_damage, "block_damage": block_damage}


func _set_footprints() -> void:
	footprints.append([Vector2i.ZERO, Vector2i(0, 1), Vector2i(0, 2)])
	footprints.append([Vector2i.ZERO, Vector2i(-1, 0), Vector2i(-2, 0)])
	footprints.append([Vector2i.ZERO, Vector2i(0, -1), Vector2i(0, -2)])

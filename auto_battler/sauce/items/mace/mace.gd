extends Item

@export_range(1, 100) var attack_damage: int
@export_range(1, 100) var block_damage: int
## TODO add armour breaking

func _get_active_effect() -> Dictionary:
	return {"attack_damage": attack_damage, "block_damage": block_damage}


func _set_footprint() -> void:
	footprint.append(Vector2i.ZERO)
	footprint.append(Vector2i(0, 1))
	footprint.append(Vector2i(0, 2))

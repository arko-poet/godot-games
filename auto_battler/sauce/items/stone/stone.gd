extends Item

@export_range(1, 100) var attack_damage: int


func _get_active_effect() -> Dictionary:
	return {"attack_damage": attack_damage}


func _set_footprints() -> void:
	footprints.append([Vector2i.ZERO])

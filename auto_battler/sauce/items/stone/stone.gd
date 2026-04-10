extends Item


@export_range(1, 100) var attack_damage: int


func _get_effect() -> Dictionary:
	return {"attack": attack_damage}

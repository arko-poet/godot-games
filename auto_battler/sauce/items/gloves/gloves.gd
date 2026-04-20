extends Item

@export_range(1, 100) var attack_damage: int
@export_range(1, 100) var break_damage: int


func get_bonus() -> Dictionary:
	return {"cooldown": 0.4}

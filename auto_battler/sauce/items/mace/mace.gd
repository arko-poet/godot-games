extends Item

@export_range(1, 100) var attack_damage: int
@export_range(1, 100) var break_damage: int


func _process(delta: float) -> void:
	print(get_local_mouse_position() * get_global_transform())


func _get_actions() -> Array[CombatAction]:
	return [
		CombatAction.new(CombatAction.Type.BREAK, break_damage, self),
		CombatAction.new(CombatAction.Type.ATTACK, attack_damage, self)
	]


func _set_footprints() -> void:
	footprints.append([Vector2i.ZERO, Vector2i(0, 1), Vector2i(0, 2)])
	footprints.append([Vector2i.ZERO, Vector2i(-1, 0), Vector2i(-2, 0)])
	footprints.append([Vector2i.ZERO, Vector2i(0, -1), Vector2i(0, -2)])
	footprints.append([Vector2i.ZERO, Vector2i(1, 0), Vector2i(2, 0)])

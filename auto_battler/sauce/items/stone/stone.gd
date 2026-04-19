extends Item

@export_range(1, 100) var attack_damage: int


func _get_actions() -> Array[CombatAction]:
	
	return [CombatAction.new(CombatAction.Type.ATTACK, attack_damage, self)]

func _set_footprints() -> void:
	footprints.append([Vector2i.ZERO])
	footprints.append([Vector2i.ZERO])
	footprints.append([Vector2i.ZERO])
	footprints.append([Vector2i.ZERO])

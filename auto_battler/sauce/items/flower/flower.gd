extends Item

@export_range(1, 100) var heal: int


func _get_actions() -> Array[CombatAction]:
	return [CombatAction.new(CombatAction.Type.HEAL, heal, self)]

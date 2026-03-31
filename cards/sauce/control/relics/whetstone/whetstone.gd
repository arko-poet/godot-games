extends Relic

@export_range(0, 100) var damage: int


func _set_tooltip():
	icon.tooltip_text = "Whetstone: deal +%s damage with attacks" % damage


func process_action(action: Action) -> Array[Action]:
	if action.type == Action.ActionType.ATTACK:
		action.value += damage
	return []

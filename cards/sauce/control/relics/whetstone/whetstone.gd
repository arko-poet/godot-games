extends Relic

@export_range(0, 100) var damage: int


func process_action(action: Action) -> Array[Action]:
	if action.type == Action.Type.ATTACK and not action.monster_action:
		action.value += damage
		_trigger_effect()
	return []
	
	
func _set_tooltip():
	icon.tooltip_text = "Whetstone: deal +%s damage with attacks" % damage

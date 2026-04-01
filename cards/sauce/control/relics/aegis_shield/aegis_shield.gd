extends Relic

@export_range(0, 100) var damage_reductin: int

var used := false


func _set_tooltip():
	icon.tooltip_text = "AegisShield: the first time you take damage each turn, reduce it by %s" % damage_reductin


func turn_ended() -> Array[Action]:
	used = false
	return []


func process_action(action: Action) -> Array[Action]:
	if action.type == Action.ActionType.ATTACK and action.monster_action:
		if not used:
			used = true
			action.value -= damage_reductin
			_trigger_effect()
	return []

extends Relic

@export_range(0, 100) var damage_reduction: int

var effect_consumed := false


func turn_ended() -> Array[Action]:
	effect_consumed = false
	return []


func process_action(action: Action) -> Array[Action]:
	if action.type == Action.Type.ATTACK and action.monster_action:
		if not effect_consumed:
			effect_consumed = true
			action.value -= damage_reduction
			_trigger_effect()
	return []


func _set_tooltip():
	icon.tooltip_text = "AegisShield: the first time you take damage each turn, reduce it by %s" % damage_reduction

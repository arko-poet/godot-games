extends Relic

@export_range(0, 100) var mana: int


func _set_tooltip():
	icon.tooltip_text = "Hermes Boots: at the start of each turn, gain %s mana" % mana


func turn_started() -> Array[Action]:
	var action = Action.new()
	action.type = Action.ActionType.MANA
	action.value = mana
	_trigger_effect()
	return [action]

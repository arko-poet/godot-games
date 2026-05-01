extends Relic

@export_range(0, 100) var mana: int


func turn_started() -> Array[Action]:
	var action = Action.new()
	action.type = Action.Type.MANA
	action.value = mana
	_trigger_effect()
	return [action]


func _set_tooltip():
	icon.tooltip_text = "Hermes Boots: at the start of each turn, gain %s mana" % mana

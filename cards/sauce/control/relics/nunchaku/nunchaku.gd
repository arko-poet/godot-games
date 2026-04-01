extends Relic

@export_range(0, 100) var block: int

func _set_tooltip():
	icon.tooltip_text = "Nunchaku: gain %s block whenever you play an Attack card" % block


func process_action(action: Action) -> Array[Action]:
	var new_actions: Array[Action] = []
	if action.type == Action.ActionType.ATTACK and not action.monster_action:
		var new_action := Action.new()
		new_action.type = Action.ActionType.BLOCK
		new_action.value = block
		new_actions.append(new_action)
	return new_actions

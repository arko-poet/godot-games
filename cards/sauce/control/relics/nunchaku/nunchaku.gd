extends Relic

@export_range(0, 100) var block: int

func _set_tooltip():
	icon.tooltip_text = "Gain %s block whenever you play an Attack card." % block


func process_action(action: Action) -> Array[Action]:
	var actions: Array[Action] = []
	actions.append(action)
	if action.type == Action.ActionType.ATTACK:
		var new_action := Action.new()
		new_action.type = Action.ActionType.BLOCK
		new_action.value = block
		actions.append(new_action)
	return actions

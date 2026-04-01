extends Relic

const COST_REDUCTION := 100

@export_range(0, 100) var trigger_at: int

var card_played_counter := 0


func card_played() -> Array[Action]:
	card_played_counter += 1
	if card_played_counter == 0:
		_trigger_effect()
		_ready_effect(false)
	elif card_played_counter == 2:
		_ready_effect(true)
	if card_played_counter == trigger_at:
		card_played_counter = -1
		var action := Action.new()
		action.type = Action.ActionType.COST
		action.value = COST_REDUCTION
		return [action]
	return []


func turn_ended() -> Array[Action]:
	card_played_counter = 0
	return []


func _set_tooltip():
	icon.tooltip_text = "Herb Pouch: every %srd card you play each turn costs 0" % (trigger_at + 1)

class_name RelicManager
extends Control

var relics: Array[Relic] = []


func _ready() -> void:
	relics.append($RelicGrid/Whetstone) # TODO remove once adding relics is possible
	relics.append($RelicGrid/Nunchaku)


func process_actions(actions: Array[Action]) -> Array[Action]:
	var new_actions: Array[Action] = []
	for action in actions:
		for relic in relics:
			for new_action in relic.process_action(action):
				if new_action not in new_actions:
					new_actions.append(new_action)
	return new_actions

class_name RelicManager
extends Control

signal relic_actions_created(actions: Array[Action])

var relics: Array[Relic] = []


func _ready() -> void:
	relics.append($RelicGrid/Whetstone) # TODO remove once adding relics is possible
	relics.append($RelicGrid/Nunchaku)
	relics.append($RelicGrid/HermesBoots)


func process_actions(actions: Array[Action]) -> Array[Action]:
	var new_actions: Array[Action] = []
	for action in actions:
		new_actions.append(action)
		for relic in relics:
			for new_action in relic.process_action(action):
				new_actions.append(new_action)
	return new_actions


func _on_combat_encounter_turn_started() -> void:
	var actions: Array[Action] = []
	for relic in relics:
		for action in relic.turn_started():
			actions.append(action)
	
	if not actions.is_empty():
		emit_signal("relic_actions_created", actions)

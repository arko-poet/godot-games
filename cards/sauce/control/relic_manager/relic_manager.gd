class_name RelicManager
extends Control

var relics: Array[Relic] = []


func _ready() -> void:
	relics.append($RelicGrid/Whetstone) # TODO remove once adding relics is possible


func process_actions(actions: Array[Action]) -> Array[Action]:
	for action in actions:
		for relic in relics:
			relic.process_action(action)
	return actions

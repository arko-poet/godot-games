class_name RelicManager
extends Control

signal relic_actions_created(actions: Array[Action])

var relics: Array[Relic] = []
var remaining_relics := [
	preload("res://sauce/control/relics/nunchaku/nunchaku.tscn"),
	preload("res://sauce/control/relics/whetstone/whetstone.tscn"),
	preload("res://sauce/control/relics/hermes_boots/hermes_boots.tscn"),
	preload("res://sauce/control/relics/herb_pouch/herb_pouch.tscn"),
	preload("res://sauce/control/relics/aegis_shield/aegis_shield.tscn")
]

@onready var relic_grid: GridContainer = $RelicGrid


## generally all combat actions should be passed through this function before they are executed
func process_actions(actions: Array[Action]) -> Array[Action]:
	var new_actions: Array[Action] = []
	for action in actions:
		new_actions.append(action)
		for relic in relics:
			for new_action in relic.process_action(action):
				new_actions.append(new_action)
	return new_actions


## only 1 relic of each kind can exist in a game run
func get_new_relic() -> Relic:
	if remaining_relics.is_empty():
		return null
	
	var relic_scene: PackedScene = remaining_relics.pop_at(randi() % remaining_relics.size())
	var relic: Relic = relic_scene.instantiate()
	return relic


func add_relic(relic: Relic) -> void:
	relics.append(relic)
	relic_grid.add_child(relic)


func _on_combat_encounter_turn_started() -> void:
	_on_event(&"turn_started")


func _on_combat_encounter_card_played() -> void:
	_on_event(&"card_played")


func _pass_relic_actions(actions: Array[Action]) -> void:
	if not actions.is_empty():
		relic_actions_created.emit(actions)


func _on_combat_encounter_turn_ended() -> void:
	_on_event(&"turn_ended")


func _on_event(relic_function: StringName) -> void:
	var actions: Array[Action] = []
	for relic in relics:
		for action in relic.call(relic_function):
			actions.append(action)
	
	_pass_relic_actions(actions)

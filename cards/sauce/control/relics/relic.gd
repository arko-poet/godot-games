class_name Relic
extends Control

@onready var icon: TextureRect = $Icon


func _ready() -> void:
	_set_tooltip()
	

func _set_tooltip():
	push_error("Base class Relic function needs to be overidden.")


func _process_action(action: Action) -> Action:
	return action

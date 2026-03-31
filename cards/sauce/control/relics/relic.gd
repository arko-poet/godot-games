class_name Relic
extends Control

@onready var icon: TextureRect = $Icon


func _ready() -> void:
	_set_tooltip()
	

func _set_tooltip():
	push_error("Base class Relic function needs to be overidden.")


func process_action(action: Action) -> Array[Action]:
	return []


func turn_started() -> Array[Action]:
	return []

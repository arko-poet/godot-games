## meant to be extended by specific relics, contains generic effects, and properties
## majority of functions return actions as some relics are capable of creating new actions
## in addition to modifying existing ones
class_name Relic
extends Control

const TRIGGER_SIZE = Vector2(1.1, 1.1)

@onready var icon: TextureRect = $Icon
@onready var particles: GPUParticles2D = $Particles


func _ready() -> void:
	_set_tooltip()


func process_action(_action: Action) -> Array[Action]:
	return []


func turn_started() -> Array[Action]:
	return []
	
	
func turn_ended() -> Array[Action]:
	return []


func card_played() -> Array[Action]:
	return []
	

## visual effect when relic effect is triggered
func _trigger_effect() -> void:
	var t = create_tween()
	t.tween_property(self, ^"scale", TRIGGER_SIZE, 0.1)
	t.tween_property(self, ^"scale", Vector2.ONE, 0.3)
	

## visual effects when relic is about to activate
func _ready_effect(on: bool) -> void:
	particles.emitting = on


func _set_tooltip():
	push_error("Base class Relic function needs to be overidden.")

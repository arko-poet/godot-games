class_name Relic
extends Control

const TRIGGER_SIZE = Vector2(1.1, 1.1)

@onready var icon: TextureRect = $Icon
@onready var particles: GPUParticles2D = $Particles


func _ready() -> void:
	_set_tooltip()


func _set_tooltip():
	push_error("Base class Relic function needs to be overidden.")


func process_action(_action: Action) -> Array[Action]:
	return []


func turn_started() -> Array[Action]:
	return []
	
	
func turn_ended() -> Array[Action]:
	return []


func card_played() -> Array[Action]:
	return []
	

func _trigger_effect() -> void:
	var t = create_tween()
	t.tween_property(self, ^"scale", TRIGGER_SIZE, 0.1)
	t.tween_property(self, ^"scale", Vector2.ONE, 0.3)
	

func _ready_effect(on: bool) -> void:
	particles.emitting = on

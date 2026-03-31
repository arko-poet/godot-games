extends Node2D

signal player_died

@onready var animation: AnimationPlayer = $Animation

func attack() -> void:
	if animation.current_animation != "attack":
		animation.animation_set_next("attack", "idle")
		animation.play("attack")
	

func die() -> void:
	animation.play("death")
	await animation.animation_finished
	player_died.emit()
	

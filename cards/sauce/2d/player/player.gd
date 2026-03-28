extends Node2D

@onready var animation: AnimationPlayer = $Animation

func attack() -> void:
	if animation.current_animation != "attack":
		animation.animation_set_next("attack", "idle")
		animation.play("attack")
	

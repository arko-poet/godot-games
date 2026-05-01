extends Node2D

signal player_died

@onready var animations: AnimationPlayer = $Animation


func attack() -> void:
	if animations.current_animation != &"attack":
		animations.animation_set_next(&"attack", &"idle")
		animations.play(&"attack")
	

func die() -> void:
	animations.play(&"death")
	await animations.animation_finished
	player_died.emit()

class_name Fireball
extends Area2D

const BASE_SPEED := 200
var direction := Vector2.ZERO

func _process(delta: float) -> void:
	position += direction * BASE_SPEED * delta

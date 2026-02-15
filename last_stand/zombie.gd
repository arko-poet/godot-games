class_name Zombie
extends StaticBody2D

const ZOMBIE_SPEED := 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var velocity := Vector2(-1, 0).normalized() * ZOMBIE_SPEED
	position += velocity * delta

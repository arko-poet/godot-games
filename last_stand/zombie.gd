class_name Zombie
extends CharacterBody2D

const ZOMBIE_SPEED := 100

func _ready() -> void:
	$Sprite.flip_h = true
	$Sprite.play("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	velocity = Vector2(-1, 0).normalized() * ZOMBIE_SPEED
	if move_and_slide():
		$Sprite.animation = "attack"

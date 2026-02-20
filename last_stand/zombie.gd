class_name Zombie
extends CharacterBody2D

const ZOMBIE_SPEED := 100

var is_attacking := false
var attack_target
var health

func _ready() -> void:
	velocity = Vector2(-1, 0) * ZOMBIE_SPEED
	health =  2 * Global.level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if move_and_slide():
		if not attack_target:
			attack_target = get_last_slide_collision().get_collider()
			$Sprite.play("attack")
	else:
		velocity = Vector2(-1, 0) * ZOMBIE_SPEED
		$Sprite.play("walk")


func _on_sprite_animation_finished() -> void:
	if attack_target:
		attack_target.hit()
	attack_target = null


func hit() -> void:
	if health > Global.projectile_damage:
		health -= Global.projectile_damage
	else:
		$Sprite.animation = "die"
		$Sprite.animation_finished.connect(func(): Global.zombies_killed += 1)
		$Collision.queue_free()
		set_physics_process(false)

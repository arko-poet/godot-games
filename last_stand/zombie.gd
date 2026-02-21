class_name Zombie
extends CharacterBody2D

var zombie_speed := 100
var attack_target
var health : int
var damage : int
var is_dead := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if move_and_slide():
		if not attack_target:
			attack_target = get_last_slide_collision().get_collider()
			$Sprite.play("attack")
	else:
		velocity = Vector2(-1, 0) * zombie_speed
		$Sprite.play("walk")


func _on_sprite_animation_finished() -> void:
	if attack_target:
		attack_target.hit(damage)
	attack_target = null


func hit() -> void:
	if health > Global.projectile_damage:
		health -= Global.projectile_damage
	elif not is_dead:
		$Sprite.play("die")
		$Sprite.animation_finished.connect(func(): Global.zombies_killed += 1)
		$Collision.queue_free()
		set_physics_process(false)
		is_dead = true

func set_type(type: int) -> void:
	# 4 zombie type: 1 normal, 2 fast, 3 tanky, 4 strong
	velocity = Vector2(-1, 0) * zombie_speed
	health =  2 * Global.level
	damage = 1
	if type == 2:
		zombie_speed *= 2
	elif type == 3:
		health *= 2
	elif type == 4:
		damage *= 2
		
		

extends CharacterBody2D


const PLAYER_SPEED := 300
const PROJECTILE_SCENE := preload("res://projectile.tscn")

var is_attacking := false
var projectile_direction : Vector2

func _physics_process(_delta) -> void:
	if not is_attacking:
		if Input.is_action_just_pressed("attack"):
			$Sprite.animation = "attack"
			is_attacking = true
			projectile_direction = Vector2(get_global_mouse_position() - position).normalized()
		else:
			var movement_direction = Vector2.ZERO
			if Input.is_action_pressed("move_down"):
				movement_direction.y += 1
			if Input.is_action_pressed("move_up"):
				movement_direction.y -= 1
			if Input.is_action_pressed("move_left"):
				movement_direction.x -= 1
			if Input.is_action_pressed("move_right"):
				movement_direction.x += 1
			
			if movement_direction.x == 1:
				$Sprite.flip_h = false
			if movement_direction.x == -1:
				$Sprite.flip_h = true
			
			velocity = movement_direction.normalized() * PLAYER_SPEED
			if movement_direction == Vector2.ZERO:
				$Sprite.animation = "idle"
			else:
				$Sprite.animation = "walk"
		$Sprite.play()
		move_and_slide()
		position = position.clamp(Vector2.ZERO + $Collision.shape.size * 0.5, get_viewport_rect().size - $Sprite.sprite_frames.get_frame_texture("walk", 0).get_size() * 0.5)


func _on_sprite_animation_finished() -> void:
	var projectile := PROJECTILE_SCENE.instantiate()
	projectile.position = Vector2(position)
	projectile.direction = projectile_direction
	projectile.rotation = projectile_direction.angle()
	get_parent().add_child(projectile)
	is_attacking = false

extends CharacterBody2D


const PLAYER_SPEED = 300


var is_attacking := false

func _physics_process(_delta) -> void:
	if not is_attacking:
		if Input.is_action_just_pressed("attack"):
			$Sprite.animation = "attack"
			is_attacking = true
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
	is_attacking = false

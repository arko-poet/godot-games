extends CharacterBody2D


const PLAYER_SPEED = 300

func _physics_process(delta) -> void:
	var movement_direction = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		movement_direction.y += 1
	if Input.is_action_pressed("move_up"):
		movement_direction.y -= 1
	if Input.is_action_pressed("move_left"):
		movement_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		movement_direction.x += 1
	
	if movement_direction == Vector2.ZERO:
		$Sprite2D.animation = "idle"
	else:
		$Sprite2D.animation = "walk"
		velocity = movement_direction.normalized() * PLAYER_SPEED
		move_and_slide()
		position = position.clamp(Vector2.ZERO + $Sprite2D.sprite_frames.get_frame_texture("walk", 0).get_size() * 0.5, get_viewport_rect().size - $Sprite2D.sprite_frames.get_frame_texture("walk", 0).get_size() * 0.5)

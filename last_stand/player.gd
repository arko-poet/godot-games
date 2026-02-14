extends Sprite2D


const PLAYER_SPEED = 500

func _process(delta) -> void:
	var movement_direction = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		movement_direction.y += 1
	if Input.is_action_pressed("move_up"):
		movement_direction.y -= 1
	if Input.is_action_pressed("move_left"):
		movement_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		movement_direction.x += 1
	
	position += movement_direction.normalized() * PLAYER_SPEED * delta
	position = position.clamp(Vector2.ZERO + texture.get_size() * 0.5, get_viewport_rect().size - texture.get_size() * 0.5)

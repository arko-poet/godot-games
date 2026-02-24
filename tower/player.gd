extends CharacterBody2D

const HORIZONTAL_ACCELERATION := 900
const MAX_SPEED := 500
const JUMP_IMPULSE := 500

func _physics_process(delta: float) -> void:
	# horizontal movement
	var dx := Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, dx * MAX_SPEED, HORIZONTAL_ACCELERATION * delta)
	
	# vertical movement
	var dy := 0.0
	if Input.is_action_pressed("jump") and is_on_floor():
		dy -= JUMP_IMPULSE + abs(velocity.x)
	dy += get_gravity().y * delta
	velocity.y += dy
	
	# wall collision
	var pre_collision_velocity := velocity
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("walls"):
			velocity = pre_collision_velocity.bounce(collision.get_normal())
			break

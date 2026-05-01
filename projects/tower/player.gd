extends CharacterBody2D

const HORIZONTAL_ACCELERATION := 900
const MAX_SPEED := 500
const JUMP_IMPULSE := 500
const SIZE := 64 # TODO set sprite and collision size to this

var last_floor := 0
var combo := 0

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
		var collider = collision.get_collider()
		if collider.is_in_group("walls"):
			velocity = pre_collision_velocity.bounce(collision.get_normal())
		else:
			var level = collider.get_level()
			var level_difference = level - last_floor
			if level_difference > 1:
				combo += level_difference
			elif level_difference == 1 or level_difference < 0:
				Globals.record_combo(combo)
				combo = 0
			last_floor = level
		break

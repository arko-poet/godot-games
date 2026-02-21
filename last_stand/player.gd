extends CharacterBody2D

const PLAYER_SPEED := 300
const PROJECTILE_SCENE := preload("res://projectile.tscn")
const PROJECTILE_CONE_ANGLE := PI / 4

var is_attacking := false
var projectile_direction : Vector2


func _ready() -> void:
	$Sprite.speed_scale = Global.cast_speed

func _physics_process(_delta) -> void:
	if not is_attacking:
		if Input.is_action_just_pressed("attack"):
			$Sprite.speed_scale = Global.cast_speed
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
			
			if movement_direction.x != 0:
				$Sprite.flip_h = movement_direction.x < 0
			else:
				$Sprite.flip_h = get_global_mouse_position().x < global_position.x
			
			velocity = movement_direction.normalized() * PLAYER_SPEED
			$Sprite.speed_scale = 1.0
			if movement_direction == Vector2.ZERO:
				$Sprite.animation = "idle"
			else:
				$Sprite.animation = "walk"
		$Sprite.play()
		move_and_slide()
		position = position.clamp(Vector2.ZERO + $Collision.shape.size * 0.5, get_viewport_rect().size - $Sprite.sprite_frames.get_frame_texture("walk", 0).get_size() * 0.5)


func _on_sprite_animation_finished() -> void:
	for angle in _get_projectile_angles():
		var projectile := PROJECTILE_SCENE.instantiate()
		projectile.position = Vector2(position)
		projectile.direction = projectile_direction.rotated(angle)
		projectile.rotation = projectile_direction.angle() + angle
		get_parent().add_child(projectile)
		is_attacking = false


func _get_projectile_angles():
	var angles : Array[float] = []
	if Global.number_of_projectiles == 1:
		angles.append(0.0)
		return angles

	# cone is divided into sections, projectiles emerge from bundries of these
	var sections : int
	var angle_step : float
	if Global.number_of_projectiles % 2 == 0:
		# for even case no projectiles on boundries of cone for lesser spread
		sections = Global.number_of_projectiles + 1
		angle_step = PROJECTILE_CONE_ANGLE / sections
		for i in range(1, sections):
			angles.append(-PROJECTILE_CONE_ANGLE * 0.5 + angle_step * i)
	else:
		angles.append(-PROJECTILE_CONE_ANGLE * 0.5)
		sections = Global.number_of_projectiles - 1
		angle_step = PROJECTILE_CONE_ANGLE / sections
		for i in range(1, sections + 1):
			angles.append(angles[0] + angle_step * i)
	return angles
	

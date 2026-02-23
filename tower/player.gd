extends CharacterBody2D


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		velocity.x = -400
	if Input.is_action_pressed("move_right"):
		velocity.x = 400
	if Input.is_action_pressed("move_up"):
		velocity.y = -400
	velocity += get_gravity() * _delta
	move_and_slide()

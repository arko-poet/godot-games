extends CharacterBody2D

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x = -400
	if Input.is_action_pressed("move_right"):
		velocity.x = 400
	if Input.is_action_pressed("move_up"):
		velocity.y = -400
	move_and_slide()
		

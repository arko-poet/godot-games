extends CharacterBody2D

var speed := 150.0


func _physics_process(_delta: float) -> void:
	# movement
	var direction := Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	velocity = direction.normalized() * speed
	move_and_slide()

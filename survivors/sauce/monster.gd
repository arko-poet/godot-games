extends CharacterBody2D


const SPEED := 100.0

var target : CharacterBody2D


func _physics_process(_delta: float) -> void:
	if target:
		var direction := target.global_position - global_position
		velocity = direction.normalized() * SPEED
		move_and_slide()

func set_target(new_target : CharacterBody2D) -> void:
	self.target = new_target

extends CharacterBody2D


const SPEED := 100.0

var target : CharacterBody2D

@onready var navigation: NavigationAgent2D = $Navigation

func _physics_process(_delta: float) -> void:
	if target:
		velocity = global_position.direction_to(navigation.get_next_path_position()) * SPEED
		move_and_slide()
		
		
		#var direction := target.global_position - global_position
		#velocity = direction.normalized() * SPEED
		#move_and_slide()

func set_target(new_target : CharacterBody2D) -> void:
	self.target = new_target


func _on_update_target_position_timeout() -> void:
	navigation.target_position = target.global_position

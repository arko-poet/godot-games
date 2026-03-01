extends CharacterBody2D


const SPEED := 100.0
var target : Node
@onready var navigation: NavigationAgent2D = $Navigation

func _physics_process(_delta: float) -> void:
	if target:
		navigation.set_velocity(global_position.direction_to(navigation.get_next_path_position()) * SPEED)

func set_target(new_target : Node) -> void:
	self.target = new_target


func _on_update_target_position_timeout() -> void:
	navigation.target_position = target.global_position


func _on_navigation_velocity_computed(safe_velocity: Vector2) -> void:
		velocity = safe_velocity
		move_and_slide()

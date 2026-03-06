class_name Monster
extends CharacterBody2D

signal monster_died

const SPEED := 100.0
const XPOrbScene := preload("res://sauce/xp_orb/xp_orb.tscn")
const KNOCKBACK_DECAY := 200.0

@export var hp := 10

var target: Node
var damage := 5
var knockback_velocity := Vector2(0, 0)

@onready var navigation: NavigationAgent2D = $Navigation
@onready var sprite: AnimatedSprite2D = $Sprite


func _physics_process(delta: float) -> void:
	if knockback_velocity.length_squared() >= 10.0:
		navigation.avoidance_enabled = false
		velocity = knockback_velocity
		move_and_slide()
	elif target:
		navigation.avoidance_enabled = true
		navigation.set_velocity(global_position.direction_to(navigation.get_next_path_position()) * SPEED)
	knockback_velocity = knockback_velocity.move_toward(Vector2(0.0, 0.0), KNOCKBACK_DECAY * delta)

func set_target(new_target: Node) -> void:
	self.target = new_target


func _on_update_target_position_timeout() -> void:
	navigation.target_position = target.global_position


func _on_navigation_velocity_computed(safe_velocity: Vector2) -> void:
		velocity = safe_velocity
		move_and_slide()


func hit(damage_recieved: int, knockback := Vector2(0.0, 0.0)) -> void:
	hp = max(0, hp - damage_recieved)
	if hp == 0:
		var xp_orb := XPOrbScene.instantiate()
		xp_orb.global_position = global_position
		get_parent().add_child(xp_orb)
		_die()
	else:
		knockback_velocity += knockback
		_hit_flash()


func _hit_flash() -> void:
	sprite.material.set_shader_parameter("flash_amount", 1.0)
	var t: Tween = create_tween()
	t.tween_method(func(x): sprite.material.set_shader_parameter("flash_amount", x), 1, 0, 0.1)
	t.play()


func _die() -> void:
	monster_died.emit()
	queue_free()

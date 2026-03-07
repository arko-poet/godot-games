class_name Projectile
extends Node2D

@export var speed : float
var damage: int
var target: Node2D
var direction: Vector2
var projectile_root: Node2D


func _on_ttl_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("monsters"):
		_monster_collision(body)
	else:
		_obstacle_collision()


func _monster_collision(monster: Monster) -> void:
	monster.call_deferred("hit", damage)


func _obstacle_collision() -> void:
	queue_free()


func _set_direction() -> void:
	if target:
		direction = (target.global_position - global_position).normalized()
	else:
		direction = Vector2(1, 0)

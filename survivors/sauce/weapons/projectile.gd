class_name Projectile
extends Node2D

var damage : int
var target : Node2D
var direction : Vector2

func _on_ttl_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("monsters"):
		body.call_deferred("hit", damage)


func _set_direction() -> void:
	if target:
		direction = (target.global_position - global_position).normalized()
	else:
		direction = Vector2(1, 0)

class_name Fireball
extends Area2D

const BASE_SPEED := 100
var direction := Vector2.ZERO
var damage : int

func _physics_process(delta: float) -> void:
	position += direction * BASE_SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("monsters"):
		body.call_deferred("hit", damage)
		queue_free()


func _on_ttl_timeout() -> void:
	queue_free()

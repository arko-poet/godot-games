class_name Projectile
extends Node2D

var damage : int
var direction : Vector2

func _on_ttl_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("monsters"):
		body.call_deferred("hit", damage)

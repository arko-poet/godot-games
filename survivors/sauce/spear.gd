class_name Spear
extends Projectile


const BASE_SPEED := 100
var pierce := 5


func _physics_process(delta: float) -> void:
	position += direction * BASE_SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("monsters"):
		body.call_deferred("hit", damage)
		if pierce > 0:
			pierce -= 1
		else:
			queue_free()

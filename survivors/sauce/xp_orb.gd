extends Area2D

var speed := 100
var target : Area2D
var xp := 1

func _physics_process(delta: float) -> void:
	if target:
		global_position += delta * speed * (target.global_position - global_position).normalized()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("magnet"):
		target = area


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("magnet"):
		target = null


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.add_xp(xp)
		queue_free()

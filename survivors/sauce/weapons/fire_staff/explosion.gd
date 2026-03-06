extends Area2D


var knockback_velocity := 200.0
var damage : int


func _ready():
	await get_tree().physics_frame
	var bodies := get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("monsters"):
			body.hit(1, (body.global_position - global_position).normalized() * knockback_velocity)
	queue_free()

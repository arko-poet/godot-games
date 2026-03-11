extends Area2D


var knockback_velocity := 200.0
var damage : int

@onready var particles: CPUParticles2D = $Particles


func _ready():
	await get_tree().physics_frame
	particles.emitting = true
	var bodies := get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("monsters"):
			body.hit(damage, (body.global_position - global_position).normalized() * knockback_velocity)


func _on_particles_finished() -> void:
	queue_free()

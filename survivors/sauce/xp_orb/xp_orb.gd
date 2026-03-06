extends Area2D

const ACCELERATION := 400.0
const INITIAL_SPEED := 200.0

var target: Area2D
var xp := 1
var direction : Vector2
var speed := 200.0
var repel_finished := false


func _physics_process(delta: float) -> void:
	if not target:
		return
		
	# repel first
	if speed > 0.0 and not repel_finished:
		global_position += delta * direction * speed
		speed = max(0.0, speed - ACCELERATION * delta)
	else: # chase player
		repel_finished = true
		direction = (target.global_position - global_position).normalized()
		global_position += delta * speed * direction
		speed += delta * ACCELERATION
		

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("magnet"):
		direction = -(area.global_position - global_position).normalized()
		target = area


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.add_xp(xp)
		queue_free()

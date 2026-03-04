extends Area2D

const MIN_CHANGE_OF_RADIUS := 50
const RATE_OF_CHANGE_OF_RADIUS := 1500
const ANGULAR_SPEED := 3.0
var damage : int
var direction : Vector2
var radius := 0.0
var angle := 0.0
var center : Vector2
var change_of_radius := 500


func _ready() -> void:
	center = global_position
	angle = direction.angle()
	

func _physics_process(delta) -> void:
	radius += change_of_radius * delta
	change_of_radius = max(MIN_CHANGE_OF_RADIUS, change_of_radius - RATE_OF_CHANGE_OF_RADIUS * delta)
	
	angle += ANGULAR_SPEED * delta
	global_position = center + Vector2(cos(angle), sin(angle)) * radius


func _on_ttl_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("monsters"):
		body.call_deferred("hit", damage)

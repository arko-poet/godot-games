class_name Bouncer
extends Projectile

var bounce := 5


func _ready() -> void:
	_set_direction()


func _physics_process(delta: float) -> void:
	rotation = direction.angle()
	position += direction * BASE_SPEED * delta


func _monster_collision(monster: Monster) -> void:
	if bounce > 0:
		bounce -= 1
		direction = -direction
	else:
		queue_free()
	monster.call_deferred("hit", damage)

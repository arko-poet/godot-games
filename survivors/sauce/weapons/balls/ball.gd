class_name Ball
extends Projectile

const BASE_SPEED := 100

var bounce := 5
var bounce_distance := 100


func _ready() -> void:
	_set_direction()


func _physics_process(delta: float) -> void:
	rotation = direction.angle()
	position += direction * BASE_SPEED * delta


func _monster_collision(monster: Monster) -> void:
	if bounce > 0:
		bounce -= 1
		_next_target()
	else:
		queue_free()
	monster.call_deferred("hit", damage)


func _next_target() -> void:
	var enemy: Node2D = Globals.find_nearest_enemy(global_position)
	if global_position.distance_to(enemy.global_position) < bounce_distance:
		target = enemy
		_set_direction()
	else:
		queue_free()

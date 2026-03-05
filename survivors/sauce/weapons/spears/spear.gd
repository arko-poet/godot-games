class_name Spear
extends Projectile

const BASE_SPEED := 300

var pierce := 5


func _ready():
	_set_direction()
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	position += direction * BASE_SPEED * delta


func _monster_collision(monster: Monster) -> void:
	if monster.is_in_group("monsters"):
		monster.call_deferred("hit", damage)
	if pierce > 0:
		pierce -= 1
	else:
		queue_free()

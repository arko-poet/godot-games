class_name Spear
extends Projectile

var pierce := 5


func _ready():
	_set_direction()
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _monster_collision(monster: Monster) -> void:
	if monster.is_in_group("monsters"):
		monster.call_deferred("hit", damage)
	if pierce > 0:
		pierce -= 1
	else:
		queue_free()

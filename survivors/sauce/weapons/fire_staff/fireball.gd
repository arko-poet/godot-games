class_name FireBall
extends Projectile

const BASE_SPEED := 100
const ExplosionScene := preload("res://sauce/weapons/fire_staff/explosion.tscn")


func _ready() -> void:
	_set_direction()


func _physics_process(delta: float) -> void:
	rotation = direction.angle()
	position += direction * BASE_SPEED * delta


func _monster_collision(_m: Monster) -> void:
	var explosion := ExplosionScene.instantiate()
	explosion.global_position = global_position
	explosion.damage = damage
	projectile_root.call_deferred("add_child", explosion)
	
	queue_free()

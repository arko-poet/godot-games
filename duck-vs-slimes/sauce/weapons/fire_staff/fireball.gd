class_name FireBall
extends Projectile

const ExplosionScene := preload("res://sauce/weapons/fire_staff/explosion.tscn")

var size_multiplier: float

func _ready() -> void:
	_set_direction()


func _physics_process(delta: float) -> void:
	rotation = direction.angle()
	position += direction * speed * delta


func _monster_collision(_m: Monster) -> void:
	var explosion := ExplosionScene.instantiate()
	explosion.global_position = global_position
	explosion.scale *= size_multiplier
	explosion.damage = damage
	projectile_root.call_deferred("add_child", explosion)
	
	queue_free()

extends Projectile

const ToxicGround := preload("res://sauce/weapons/toxic_weapon/toxic_ground.tscn")

var size_multiplier: float

func _ready() -> void:
	_set_direction()


func _physics_process(delta: float) -> void:
	rotation += delta * TAU * 2
	position += direction * speed * delta


func _monster_collision(_m: Monster) -> void:
	var toxic_ground := ToxicGround.instantiate()
	toxic_ground.scale *= size_multiplier
	toxic_ground.global_position = global_position
	toxic_ground.damage = damage
	projectile_root.call_deferred("add_child", toxic_ground)
	
	queue_free()

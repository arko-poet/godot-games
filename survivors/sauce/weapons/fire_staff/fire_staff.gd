extends Weapon

const FireBallScene := preload("res://sauce/weapons/fire_staff/fireball.tscn")


func _attack() -> void:
	var fireball: FireBall = FireBallScene.instantiate()
	fireball.scale *= size_multiplier
	fireball.size_multiplier = size_multiplier
	fireball.damage = int(base_damage * damage_multiplier)
	fireball.projectile_root = projectile_root
	if target:
		fireball.target = target
	fireball.global_position = global_position
	projectile_root.add_child(fireball)

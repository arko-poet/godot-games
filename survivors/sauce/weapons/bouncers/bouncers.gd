extends Weapon

const BouncerScene := preload("res://sauce/weapons/bouncers/bouncer.tscn")


func _attack() -> void:
	var bouncer: Bouncer = BouncerScene.instantiate()
	bouncer.damage = int(base_damage * damage_multiplier)
	if target:
		bouncer.target = target
	bouncer.global_position = global_position
	projectile_root.add_child(bouncer)

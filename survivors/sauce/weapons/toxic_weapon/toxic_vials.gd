extends Weapon

const ToxicVial := preload("res://sauce/weapons/toxic_weapon/toxic_vial.tscn")

func _attack():
	var toxic_vial := ToxicVial.instantiate()
	toxic_vial.damage = int(base_damage * damage_multiplier)
	toxic_vial.projectile_root = projectile_root
	if target:
		toxic_vial.target = target
	toxic_vial.global_position = global_position
	projectile_root.add_child(toxic_vial)

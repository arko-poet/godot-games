extends Weapon

const SpearScene := preload("res://sauce/weapons/spears/spear.tscn")


func _attack() -> void:
	var spear: Spear = SpearScene.instantiate()
	spear.scale *= size_multiplier
	spear.target = target
	spear.damage = int(base_damage * damage_multiplier)
	spear.global_position = global_position
	projectile_root.add_child(spear)

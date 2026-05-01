extends Weapon

const Chakram := preload("res://sauce/weapons/chakrams/chakram.tscn")


func _attack():
	var chakram := Chakram.instantiate()
	chakram.scale *= size_multiplier
	chakram.damage = int(base_damage * damage_multiplier)
	chakram.target = target
	chakram.global_position = global_position
	projectile_root.add_child(chakram)

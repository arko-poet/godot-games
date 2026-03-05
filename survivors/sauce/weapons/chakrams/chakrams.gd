extends Weapon


const Chakram := preload("res://sauce/weapons/chakrams/chakram.tscn")


func _attack():
	var chakram := Chakram.instantiate()
	chakram.damage = damage
	chakram.target = target
	chakram.global_position = global_position
	projectile_root.add_child(chakram)

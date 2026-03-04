extends Weapon


const Chakram := preload("res://sauce/chakram.tscn")


func _attack():
	var chakram := Chakram.instantiate()
	if target:
		chakram.direction = (target - global_position).normalized()
	else:
		chakram.direction  = Vector2(1, 0)
	chakram.damage = damage
	chakram.global_position = global_position
	projectile_root.add_child(chakram)

extends Weapon

const SpearScene := preload("res://sauce/spear.tscn")


func _attack() -> void:
	var spear : Spear = SpearScene.instantiate()
	spear.damage = damage
	if target:
		spear.direction = (target - global_position).normalized()
		spear.rotation = spear.direction.angle()
	else:
		spear.direction  = Vector2(1, 0)
	spear.global_position = global_position
	projectile_root.add_child(spear)

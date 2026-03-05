extends Weapon

const SpearScene := preload("res://sauce/spear.tscn")


func _attack() -> void:
	var spear : Spear = SpearScene.instantiate()
	spear.target = target
	spear.damage = damage
	spear.global_position = global_position
	projectile_root.add_child(spear)

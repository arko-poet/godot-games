extends Weapon

const Fireball := preload("res://sauce/fireball.tscn")


func _attack() -> void:
	var fireball := Fireball.instantiate()
	fireball.global_position = global_position
	projectile_root.add_child(fireball)

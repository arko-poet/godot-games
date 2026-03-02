extends Weapon

const FireballScene := preload("res://sauce/fireball.tscn")


func _attack() -> void:
	var fireball : Fireball = FireballScene.instantiate()
	if target:
		fireball.direction = (target.global_position - global_position).normalized()
		fireball.rotation = fireball.direction.angle()
	else: 
		fireball.direction = Vector2(1, 0)
	fireball.global_position = global_position
	projectile_root.add_child(fireball)

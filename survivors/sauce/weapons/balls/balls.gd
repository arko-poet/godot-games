extends Weapon

const BallScene := preload("res://sauce/weapons/balls/ball.tscn")


func _attack() -> void:
	var ball: Ball = BallScene.instantiate()
	ball.damage = damage
	if target:
		ball.target = target
	ball.global_position = global_position
	projectile_root.add_child(ball)

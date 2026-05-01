extends StaticBody2D


func hit(damage : int):
	Global.health -= damage
	if Global.health <= 0:
		Global.health = 0
		queue_free()

extends StaticBody2D


func hit():
	Global.health -= 1
	if Global.health <= 0:
		queue_free()

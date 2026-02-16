extends StaticBody2D


var health := 100


func hit():
	health -= 1
	if health <= 0:
		queue_free()

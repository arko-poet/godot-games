extends Node2D


func _draw() -> void:
	var camera_rect := Rect2(Vector2(25, 25), Vector2(50, 50))
	draw_rect(camera_rect, Color.WHITE, false)

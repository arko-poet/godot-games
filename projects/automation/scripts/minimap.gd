extends Node2D

@onready var camera: Camera2D = %Camera


func _draw() -> void:
	var viewport_rect_size := get_viewport_rect().size
	var camera_rect_size := _get_camera_rect_size()
	var camera_rect := Rect2((viewport_rect_size - camera_rect_size) / 2.0, camera_rect_size)
	draw_rect(camera_rect, Color.WHITE, false)


func _get_camera_rect_size() -> Vector2:
	if camera.zoom == Vector2(0.1, 0.1):
		return get_viewport_rect().size
	return get_viewport_rect().size

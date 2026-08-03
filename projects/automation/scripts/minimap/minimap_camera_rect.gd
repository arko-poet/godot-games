extends Control

@onready var camera: Camera2D = %Camera


func _draw() -> void:
	var viewport_rect_size := get_viewport_rect().size
	var camera_rect_size := (viewport_rect_size / 5) / camera.zoom + Vector2.ONE
	var camera_rect := Rect2((viewport_rect_size - camera_rect_size) / 2.0, camera_rect_size)
	draw_rect(camera_rect, Color.WHITE, false)
	print(camera_rect)


func _on_camera_zoom_changed(_new_zoom: Vector2) -> void:
	queue_redraw()

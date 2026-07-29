extends Control

@onready var camera: Camera2D = %Camera


func _draw() -> void:
	var viewport_rect_size := get_viewport_rect().size
	var camera_rect_size := _get_camera_rect_size()
	var camera_rect := Rect2((viewport_rect_size - camera_rect_size) / 2.0, camera_rect_size)
	draw_rect(camera_rect, Color.WHITE, false)


func _get_camera_rect_size() -> Vector2:
	return (get_viewport_rect().size * 0.25) / camera.zoom


func _on_camera_zoom_changed(new_zoom: Vector2) -> void:
	queue_redraw()

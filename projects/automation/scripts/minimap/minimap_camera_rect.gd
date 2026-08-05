extends Control

@onready var camera: Camera2D = %Camera
@onready var minimap_camera: Camera2D = %MinimapCamera


func _draw() -> void:
	var main_viewport_size := camera.get_viewport_rect().size
	var frustum_size := main_viewport_size / camera.zoom / World.TILE_SIZE
	# + Vector2.ONE is so that rectangle is visible at all zoom levels
	var camera_rect_size := frustum_size * minimap_camera.zoom + Vector2.ONE
	var camera_rect := Rect2((get_viewport_rect().size - camera_rect_size) / 2.0, camera_rect_size)
	draw_rect(camera_rect, Color.WHITE, false)


func _on_camera_zoom_changed(_new_zoom: Vector2) -> void:
	queue_redraw()

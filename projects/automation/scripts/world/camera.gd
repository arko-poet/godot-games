extends Camera2D

signal chunk_changed(chunk: Vector2i)
signal zoom_changed(new_zoom: Vector2)

const _EDGE_SCROLL_SPEED := 200.0
const _SCREEN_BOUNDARY_WIDTH := 10.0
const _CAMERA_ZOOM_STEP := Vector2(0.1, 0.1)
const LOWEST_ZOOM := Vector2(0.2, 0.2)

var _chunk := Vector2i.ZERO:
	set(value):
		if _chunk != value:
			_chunk = value
			chunk_changed.emit(_chunk)


func _process(delta: float) -> void:
	var scroll_direction := Vector2i.ZERO
	var mouse_position := get_viewport().get_mouse_position()
	var viewport_size := get_viewport_rect().size

	if mouse_position.x <= _SCREEN_BOUNDARY_WIDTH and mouse_position.x > -_SCREEN_BOUNDARY_WIDTH:
		scroll_direction.x = -1
	if (
		mouse_position.x >= viewport_size.x - _SCREEN_BOUNDARY_WIDTH
		and mouse_position.x < viewport_size.x + _SCREEN_BOUNDARY_WIDTH
	):
		scroll_direction.x = 1
	if mouse_position.y <= _SCREEN_BOUNDARY_WIDTH and mouse_position.y > -_SCREEN_BOUNDARY_WIDTH:
		scroll_direction.y = -1
	if (
		mouse_position.y >= viewport_size.y - _SCREEN_BOUNDARY_WIDTH
		and mouse_position.y < viewport_size.y + _SCREEN_BOUNDARY_WIDTH
	):
		scroll_direction.y = 1

	position += (scroll_direction * _EDGE_SCROLL_SPEED * delta) / zoom
	_update_chunk()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_change_zoom(_CAMERA_ZOOM_STEP)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_change_zoom(-_CAMERA_ZOOM_STEP)
			


func _update_chunk() -> void:
	var centered_position := position + get_viewport_rect().size / 2
	var chunk := Vector2i.ZERO

	if centered_position.x < 0:
		chunk.x -= 1
	if centered_position.y < 0:
		chunk.y -= 1

	chunk += Vector2i(centered_position / (World.CHUNK_SIZE * World.TILE_SIZE))

	_chunk = chunk


func _change_zoom(addend: Vector2) -> void:
	zoom = LOWEST_ZOOM.max(zoom + addend)
	zoom_changed.emit(zoom)

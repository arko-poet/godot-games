extends Camera2D

signal chunk_changed(new_chunk: Vector2i)

const CAMERA_SPEED := 200
const SCREEN_BOUNDARY_WIDTH := 10

var chunk := Vector2i.ZERO:
	set(value):
		if chunk != value:
			chunk = value
			chunk_changed.emit(chunk)


func _process(delta: float) -> void:
	var direction := Vector2i.ZERO
	var mouse_position := get_local_mouse_position()
	var viewport_size := get_viewport_rect().size
	
	if mouse_position.x <= SCREEN_BOUNDARY_WIDTH and mouse_position.x > -SCREEN_BOUNDARY_WIDTH:
		direction.x = -1
	if (
			mouse_position.x >= viewport_size.x - SCREEN_BOUNDARY_WIDTH
			and mouse_position.x < viewport_size.x + SCREEN_BOUNDARY_WIDTH
	):
		direction.x = 1
	if mouse_position.y <= SCREEN_BOUNDARY_WIDTH and mouse_position.y > -SCREEN_BOUNDARY_WIDTH:
		direction.y = -1
	if (
			mouse_position.y >= viewport_size.y - SCREEN_BOUNDARY_WIDTH
			and mouse_position.y < viewport_size.y + SCREEN_BOUNDARY_WIDTH
	):
		direction.y = 1
		
	position += direction * CAMERA_SPEED * delta
	_update_chunk()
	
	
func _update_chunk() -> void:
	var centered_position := position + get_viewport_rect().size / 2
	var new_chunk := Vector2i.ZERO
	
	if centered_position.x < 0:
		new_chunk.x -= 1
	if centered_position.y < 0:
		new_chunk.y -= 1
	
	new_chunk += Vector2i(centered_position / (World.CHUNK_SIZE * World.TILE_SIZE))
	
	chunk = new_chunk

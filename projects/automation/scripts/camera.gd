extends Camera2D

const CAMERA_SPEED := 200
const SCREEN_BOUNDARY_WIDTH := 10


func _process(delta: float) -> void:
	var direction := Vector2i.ZERO
	var mouse_position := get_local_mouse_position()
	var viewport_size := get_viewport_rect().size
	
	if mouse_position.x <= SCREEN_BOUNDARY_WIDTH:
		direction.x = -1
	if mouse_position.x >= viewport_size.x - SCREEN_BOUNDARY_WIDTH:
		direction.x = 1
	if mouse_position.y <= SCREEN_BOUNDARY_WIDTH:
		direction.y = -1
	if mouse_position.y >= viewport_size.y - SCREEN_BOUNDARY_WIDTH:
		direction.y = 1
		
	position += direction * CAMERA_SPEED * delta

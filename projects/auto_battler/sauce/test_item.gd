extends RigidBody2D

var dragging = false
var drag_offset = Vector2.ZERO


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# start drag
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag()


func _input(event: InputEvent) -> void:
	# release drag
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.pressed:
				stop_drag()


func start_drag():
	freeze = true
	dragging = true
	drag_offset = global_position - get_global_mouse_position()


func stop_drag():
	freeze = false
	var mouse_velocity := Input.get_last_mouse_velocity()
	var mouse_direction := mouse_velocity.normalized()
	var mouse_magnitude := mouse_velocity.length()
	print(Input.get_last_mouse_velocity())
	apply_central_impulse(mouse_direction * min(mouse_magnitude, get_gravity().length()))

	dragging = false



func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset


func _on_mouse_shape_entered(_shape_idx: int) -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_mouse_shape_exited(_shape_idx: int) -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

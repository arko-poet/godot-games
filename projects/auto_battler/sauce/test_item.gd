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
	dragging = false


func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

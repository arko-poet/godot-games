extends RigidBody2D

var dragging = false
var drag_offset = Vector2.ZERO


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#print(event)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:
				print("press")
				start_drag()
			else:
				print("release")
				stop_drag()


func start_drag():
	dragging = true
	drag_offset = global_position - get_global_mouse_position()


func stop_drag():
	dragging = false


func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

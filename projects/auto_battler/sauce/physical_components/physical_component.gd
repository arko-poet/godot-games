class_name PhysicalComponent extends RigidBody2D

var dragging = false
var drag_offset = Vector2.ZERO

var inventory_component: InventoryComponent

@onready var collision: CollisionShape2D = $Collision


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# start drag
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag()


#func _input(event: InputEvent) -> void:
	## release drag
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if not event.pressed:
				#stop_drag(global_position)


func start_drag() -> void:
	# drag preview is the only thing visible during dragging
	# both physical and inventory components are hidden
	hide()
	
	inventory_component.test_drag(global_position)

	
	freeze = true
	dragging = true
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = true
	
	drag_offset = global_position - get_global_mouse_position()


func stop_drag(p_position: Vector2) -> void:
	global_position = p_position
	
	show()
	
	freeze = false
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = false
			
	var mouse_velocity := Input.get_last_mouse_velocity()
	var mouse_direction := mouse_velocity.normalized()
	var mouse_magnitude := mouse_velocity.length()
	apply_central_impulse(mouse_direction * min(mouse_magnitude, get_gravity().length()))

	dragging = false


func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

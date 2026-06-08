class_name RigidComponent extends RigidBody2D

const MAX_VELOCITIES_STORED := 10

var is_dragging = false
var drag_offset = Vector2.ZERO
var inventory_component: InventoryComponent

var recent_mouse_positions: Array[Vector2]
var recent_deltas: Array[float]

@onready var collision: CollisionShape2D = $Collision


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# start drag
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag()


func _process(delta) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset
		
		# for release impulse calculation
		if recent_mouse_positions.size() == MAX_VELOCITIES_STORED:
			recent_mouse_positions.pop_front()
			recent_deltas.pop_front()
		recent_mouse_positions.append(get_global_mouse_position())
		recent_deltas.append(delta)


#func _input(event: InputEvent) -> void:
	## release drag
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if not event.pressed:
				#stop_drag(global_position)


func start_drag() -> void:
	switch(false)

	inventory_component.position = global_position
	inventory_component.start_dragging()

	drag_offset = global_position - get_global_mouse_position()


func stop_drag(p_position: Vector2) -> void:
	switch()
	global_position = p_position
	
	var change_in_position := recent_mouse_positions[-1] - recent_mouse_positions[0]
	var total_delta := 0.0
	for dt in recent_deltas:
		total_delta += dt
	var mouse_velocity = change_in_position / total_delta
	
	var mouse_direction := mouse_velocity.normalized()
	var mouse_magnitude := mouse_velocity.length()
	apply_central_impulse(mouse_direction * min(mouse_magnitude, get_gravity().length()))


## enables/disable items interaction with the game
func switch(on: bool = true) -> void:
	freeze = !on
	is_dragging = !on
	
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = !on
	
	if on: show()
	else: hide()


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

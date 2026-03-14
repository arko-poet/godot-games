extends PanelContainer

const HOVER_Y := -100.0
const HOVER_SCALE := 1.2

var pre_hover_rotation: float
var pre_hover_position: Vector2
var is_dragging := false
var hand : Hand
var drag_offset := Vector2.ZERO

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset


func _on_mouse_entered() -> void:
	if not is_dragging:
		print("card hover")
		pre_hover_rotation = rotation
		pre_hover_position = position
		
		z_index += 1
		scale *= HOVER_SCALE
		position.y = HOVER_Y
		rotation = 0


func _on_mouse_exited() -> void:
	if not is_dragging:
		z_index -= 1
		scale /= 1.2
		position = pre_hover_position
		rotation = pre_hover_rotation


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		is_dragging = true
		drag_offset = get_global_mouse_position() - global_position
		hand = get_parent()
		var gp = global_position
		hand.remove_child(self)
		hand.get_parent().add_child(self)
		global_position = gp
			

func _input(event: InputEvent) -> void:
	if is_dragging and event is InputEventMouseButton and not event.pressed:
		is_dragging = false
		get_parent().remove_child(self)
		hand.add_child(self)

extends PanelContainer

const HOVER_Y := -100.0
const HOVER_SCALE := 1.2

var pre_hover_rotation: float
var pre_hover_position: Vector2


func _on_mouse_entered() -> void:
	pre_hover_rotation = rotation
	pre_hover_position = position
	
	z_index += 1
	scale *= HOVER_SCALE
	position.y = HOVER_Y
	rotation = 0


func _on_mouse_exited() -> void:
	z_index -= 1
	scale /= 1.2
	position = pre_hover_position
	rotation = pre_hover_rotation

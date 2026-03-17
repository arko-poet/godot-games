class_name Card
extends PanelContainer

signal card_discarded(card: Card)
signal stopped_dragging
signal stopped_hovering

const HOVER_Y := -86.0
const HOVER_SCALE := 1.2

var is_dragging := false
var hand : Hand
var drag_offset := Vector2.ZERO


func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset


func _notification(what: int) -> void:
	if what == NOTIFICATION_PARENTED:
		if get_parent() is Hand:
			hand = get_parent()
	elif what == NOTIFICATION_WM_MOUSE_EXIT and is_dragging:
		_stop_dragging(false)


func _on_mouse_entered() -> void:
	print("_mouse_entered")
	if not is_dragging and not hand.is_dragging:
		_start_hovering()


func _start_hovering() -> void:
	print("_start_hovering")
	if not hand.is_dragging:
		z_index = 1
		scale = Vector2(HOVER_SCALE, HOVER_SCALE)
		position.y = HOVER_Y
		rotation = 0


func _on_mouse_exited() -> void:
	print("mouse exited")
	if not is_dragging:
		_stop_hovering()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("left pressed")
		is_dragging = true
		hand.is_dragging = true
		drag_offset = get_global_mouse_position() - global_position
	elif event is InputEventMouseButton and not event.pressed and is_dragging:
		print("left released")
		_stop_dragging(not event.button_index == MOUSE_BUTTON_RIGHT)


func _stop_hovering() -> void:
	print("_stop_hovering")
	if not hand.is_dragging:
		stopped_hovering.emit()

func _stop_dragging(play: bool) -> void:
	print("_stop_dragging, play = %s" % play)
	if global_position.y < get_viewport_rect().size.y - 2 * size.y and play:
		_play_card()
		stopped_dragging.emit()
	else:
		stopped_dragging.emit()
		if _is_hovering():
			_start_hovering()
		is_dragging = false


func _play_card() -> void:
	_discard()


func _discard() -> void:
	emit_signal("card_discarded", self)


func _is_hovering() -> bool:
	return get_global_rect().has_point(get_global_mouse_position())

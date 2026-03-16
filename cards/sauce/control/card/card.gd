class_name Card
extends PanelContainer

signal card_discarded(card: Card)
signal stopped_dragging
signal stopped_hovering

const HOVER_Y := -100.0
const HOVER_SCALE := 1.2

var is_dragging := false
var is_hovering := false
var hand : Hand
var drag_offset := Vector2.ZERO


func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset


func _notification(what: int) -> void:
	if what == NOTIFICATION_PARENTED:
		if get_parent() is Hand:
			hand = get_parent()
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		_stop_dragging()
		_stop_hovering()


func _on_mouse_entered() -> void:
	print("yep")
	print(is_dragging)
	print(is_hovering)
	print(hand.is_dragging)
	if not is_dragging and not is_hovering and not hand.is_dragging:
		_start_hovering()


func _start_hovering() -> void:
	z_index = 1
	scale = Vector2(HOVER_SCALE, HOVER_SCALE)
	position.y = HOVER_Y
	rotation = 0
	is_hovering = true


func _on_mouse_exited() -> void:
	if not is_dragging and is_hovering:
		_stop_hovering()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and is_hovering:
		is_dragging = true
		hand.is_dragging = true
		drag_offset = get_global_mouse_position() - global_position
	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and is_dragging:
		_stop_dragging()


func _stop_hovering() -> void:
	if is_hovering:
		stopped_hovering.emit()
		is_hovering = false


func _input(event: InputEvent) -> void:
	if is_dragging and event is InputEventMouseButton and not event.pressed:
		_stop_dragging()


func _stop_dragging() -> void:
	if global_position.y < get_viewport_rect().size.y - 2 * size.y:
		_play_card()
	else:
		stopped_dragging.emit()
		if is_hovering:
			_start_hovering()
		is_dragging = false
	hand.is_dragging = false


func _play_card() -> void:
	_discard()


func _discard() -> void:
	emit_signal("card_discarded", self)

class_name Card
extends PanelContainer

signal card_played(card: Card)
signal dragging_changed(is_dragging: bool)
signal stopped_hovering

const HOVER_Y := -86.0
const HOVER_SCALE := 1.2

var is_dragging := false:
	set(value):
		is_dragging = value
		emit_signal("dragging_changed", value)
		if value:
			drag_offset = get_global_mouse_position() - global_position
var hand: Hand
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
	if not hand.is_dragging:
		_start_hovering()


func _on_mouse_exited() -> void:
	if not is_dragging:
		_stop_hovering()
		

func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = true
	elif not event.pressed: # and is_dragging
		_stop_dragging(event.button_index != MOUSE_BUTTON_RIGHT)


func _start_hovering() -> void:
	if not hand.is_dragging:
		z_index = 1
		scale = Vector2(HOVER_SCALE, HOVER_SCALE)
		position.y = HOVER_Y
		rotation = 0


func _stop_hovering() -> void:
	if not hand.is_dragging:
		stopped_hovering.emit()


## play is true if intent is to play a card, otherwise intent is to drop it
func _stop_dragging(play: bool) -> void:
	var play_boundary := get_viewport_rect().size.y - 2 * size.y
	if global_position.y < play_boundary and play:
		_play_card()
		is_dragging = false
	else: # cards go back to hand if outside of play region
		is_dragging = false
		if _is_hovering():
			_start_hovering()
	# dont set is_dragging here - the order matters
		

func _play_card() -> void:
	emit_signal("card_played", self)


func _is_hovering() -> bool:
	return get_global_rect().has_point(get_global_mouse_position())

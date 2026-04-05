@tool
class_name Hand
extends Container

signal card_played(card: Card)
signal card_rejected(card: Card)
signal cost_changed

const HOVER_SCALE := Vector2(1.0, 1.0)
const MAX_CARDS := 10

@export var max_angle: float = 18.0 ## maximum card spread
@export var card_size := Vector2(160, 225)
@export var angle_per_card := 3.0 ## ideal spread per card

var is_dragging := false:
	set(value):
		is_dragging = value
		if value:
			drag_offset = get_global_mouse_position() - active_card.global_position
		else:
			_arrange_cards()
var drag_offset: Vector2 ## cursor offset relative to cursor when starting to drag
var active_card: Card ## card that user is interacting with
var active_index: int ## previous card index before it became active
var next_candidate: Card ## most recent card hovered over thats not active_card


func _ready():
	if Engine.is_editor_hint():
		queue_sort()


func _process(_delta):
	if is_dragging:
		active_card.global_position = get_global_mouse_position() - drag_offset


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_MOUSE_EXIT and is_dragging:
		_stop_dragging(false)


func _get_minimum_size() -> Vector2:
	return card_size


func add_card(card: Card) -> void:
	if get_child_count() == 10:
		_reject_card(card)
	else:
		card.card_entered.connect(_on_card_entered)
		card.card_exited.connect(_on_card_exited)
		add_child(card)


func pop_card() -> void:
	var count = get_child_count()
	for i in count:
		remove_child(get_child(i))
		return


func clear() -> Array[Card]:
	var cards: Array[Card] = []
	for c in get_children():
		cards.append(c)
		remove_card(c)
	active_card = null
	next_candidate = null
	return cards


func remove_card(card: Card) -> void:
	remove_child(card)
	card.disconnect("card_entered", _on_card_entered)
	card.disconnect("card_exited", _on_card_exited)


func set_to_default_card_properties() -> void:
	for c in get_children():
		if c is not Card:
			continue
		(c as Card).set_to_default_properties()
	cost_changed.emit()


## cards are arranged in a fan shape
func _arrange_cards() -> void:
	print("arrange")
	if active_card and _is_hovering(active_card):
		return
	var fan_radius := size.x
	var count = get_child_count()
	var total_angle = min(max_angle, angle_per_card * (count - 1))
	for i in count:
		var card: Card = get_child(i)
		
		var interpolation_weight = 0.5
		if count > 1:
			interpolation_weight = float(i) / (count - 1)
		var angle = deg_to_rad(lerp(-total_angle, total_angle, interpolation_weight))
		var offset = Vector2(0.5 * (fan_radius - card_size.x), fan_radius)
		
		
		#fit_child_in_rect(card, Rect2(Vector2(sin(angle), -cos(angle)) * fan_radius + offset, card_size))
		#card.rotation = angle
		#card.position = Vector2(sin(angle), -cos(angle)) * fan_radius + offset
		var target_position = Vector2(sin(angle), -cos(angle)) * fan_radius + offset
		if card == active_card or card.position == target_position:
			continue
		var t := card.transform_tween
		if t and t.is_running():
			t.stop()
		t = create_tween()
		t.set_parallel()
		t.tween_property(card, ^"rotation", angle, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		t.tween_property(card, ^"position", target_position, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		card.z_index = 0
		card.scale = Vector2(0.8, 0.8)


func reduce_card_costs(cost_reduction: int):
	for child in get_children():
		if child is not Card:
			continue
		(child as Card).cost -= cost_reduction
	cost_changed.emit()


func _on_sort_children() -> void:
	_arrange_cards()


func _on_card_entered(card: Card) -> void:
	if not active_card:
		active_card = card
		active_index = active_card.get_index()
		move_child(active_card, get_child_count() - 1)
		print("start hovering")
		_start_hovering()
	else:
		next_candidate = card


func _on_card_exited(card: Card) -> void:
	if card == active_card and not is_dragging:
		move_child(active_card, active_index)
		active_card = null
		_arrange_cards()


func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or not active_card:
		return
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and active_card.playable:
		is_dragging = true
	elif not event.pressed: # and is_dragging
		_stop_dragging(event.button_index != MOUSE_BUTTON_RIGHT)


## called when card is released
## play is true if intent is to play a card, otherwise back to hand
func _stop_dragging(play: bool) -> void:
	# check if card above hand and play if so, otherwise drop it back to hand
	if active_card.global_position.y + active_card.size.y < global_position.y and play:
		_play_card(active_card)
		is_dragging = false
		active_card = null
	else: # is_dragging must be set after play, otherwise set it immediatly
		is_dragging = false
		# check if hovering is needed
		if _is_hovering(active_card):
			_start_hovering()
		elif next_candidate and _is_hovering(next_candidate):
			active_card = next_candidate
			_start_hovering()
		else:
			active_card = null


func _play_card(card: Card) -> void:
	remove_card(card)
	card_played.emit(card)


func _is_hovering(card: Card) -> bool:
	var mp := get_global_mouse_position()
	return card.get_global_rect().has_point(mp) and mp.y <= get_viewport_rect().size.y


func _start_hovering() -> void:
	if active_card.transform_tween and active_card.transform_tween.is_running():
		active_card.transform_tween.stop()
	if is_dragging:
		return
	active_card.z_index = 1
	active_card.rotation = 0
	active_card.scale = HOVER_SCALE
	active_card.global_position.y = (
		get_viewport_rect().size.y
		- active_card.get_global_rect().size.y
	)


func _reject_card(card: Card) -> void:
	card_rejected.emit(card)


func _on_combat_encounter_turn_ended() -> void:
	for child in get_children():
		if child is not Card:
			continue
		child.set_to_default_properties()

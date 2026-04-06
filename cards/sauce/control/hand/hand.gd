## probably worst piece of code Ive written in my life, it's cursed
## has been refactored many times
## breaks every time I modify something
@tool
class_name Hand
extends Container

signal card_played(card: Card)
signal card_rejected(card: Card)
signal cost_changed

enum CardState {IDLE, HOVERED, DRAGGED, ANIMATED}

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
var card_tweens: Dictionary[Card, Tween] = {}
var card_states: Dictionary[Card, CardState] = {}


func _ready():
	if Engine.is_editor_hint():
		queue_sort()


func _process(_delta):
	# testing
	var count_dragged := 0
	var count_hovered := 0
	for c in card_states:
		if card_states[c] == CardState.DRAGGED:
			count_dragged += 1
		elif card_states[c] == CardState.HOVERED:
			count_hovered += 1
	assert(count_dragged + count_hovered < 2)
	
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
		card_states[card] = CardState.IDLE
		add_child(card)


#func pop_card() -> void:
	#var count = get_child_count()
	#for i in count:
		#remove_child(get_child(i))
		#return


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
	card.card_entered.disconnect(_on_card_entered)
	card.card_exited.disconnect(_on_card_exited)
	card_states.erase(card)
	card_tweens.erase(card)


func set_to_default_card_properties() -> void:
	for c in get_children():
		if c is not Card:
			continue
		(c as Card).set_to_default_properties()
	cost_changed.emit()


## cards are arranged in a fan shape
func _arrange_cards() -> void:
	if active_card:
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
		var target_position = Vector2(sin(angle), -cos(angle)) * fan_radius + offset
		
		if card.position == target_position:
			continue
		_stop_card_animation(card)
		var t := create_tween()
		card_tweens[card] = t
		t.set_trans(Tween.TRANS_CUBIC)
		t.set_ease(Tween.EASE_OUT)
		t.set_parallel()
		t.tween_property(card, ^"rotation", angle, 0.3)
		t.tween_property(card, ^"position", target_position, 0.3)
		card_states[card] = CardState.ANIMATED
		t.finished.connect(_stop_card_animation.bind(card))
		card.scale = Vector2(0.8, 0.8)


func _stop_card_animation(card: Card) -> void:
	if card_states[card] == CardState.ANIMATED:
		card_tweens[card].stop()
	card_states[card] = CardState.IDLE


func reduce_card_costs(cost_reduction: int):
	for c in get_children():
		if c is not Card:
			continue
		c.cost -= cost_reduction
	cost_changed.emit()


func _on_sort_children() -> void:
	_arrange_cards()


func _on_card_entered(card: Card) -> void:
	if not active_card:
		_start_hovering(card)
	else:
		next_candidate = card


func _on_card_exited(card: Card) -> void:
	if card == active_card and not is_dragging:
		move_child(active_card, active_index)
		card_states[card] = CardState.IDLE
		active_card = null
		_arrange_cards()


func _on_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or not active_card:
		return
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and active_card.playable:
		card_states[active_card] = CardState.DRAGGED
		is_dragging = true
	elif not event.pressed:
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
		move_child(active_card, active_index)
		# check if hovering is needed
		#if next_candidate and _is_hovering(next_candidate):
			#_start_hovering(next_candidate)
		#else:
		card_states[active_card] = CardState.IDLE
		active_card = null
		_arrange_cards()


func _play_card(card: Card) -> void:
	remove_card(card)
	card_played.emit(card)


func _is_hovering(card: Card) -> bool:
	var mp := get_global_mouse_position()
	return card.get_global_rect().has_point(mp) and mp.y <= get_viewport_rect().size.y


func _start_hovering(card: Card) -> void:
	if active_card:
		return
	_stop_card_animation(card)
	card_states[card] = CardState.HOVERED
	active_index = card.get_index()
	active_card = card
	move_child(card, get_child_count() - 1)
	card.rotation = 0
	card.scale = HOVER_SCALE
	card.global_position.y = get_viewport_rect().size.y - card.get_global_rect().size.y


func _reject_card(card: Card) -> void:
	card_rejected.emit(card)


func _on_combat_encounter_turn_ended() -> void:
	for c in get_children():
		if c is not Card:
			continue
		c.set_to_default_properties()

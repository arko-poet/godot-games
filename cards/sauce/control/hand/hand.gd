@tool
class_name Hand
extends Container

const HOVER_SCALE := Vector2(1.2, 1.2)
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


func _arrange_cards() -> void:
    var fan_radius := size.x
    var count = get_child_count()
    var total_angle = min(max_angle, angle_per_card * (count - 1))
    for i in count:
        var card: Control = get_child(i)
        
        var interpolation_weight = 0.5
        if count > 1:
            interpolation_weight = float(i) / (count - 1)
        var angle = deg_to_rad(lerp(-total_angle, total_angle, interpolation_weight))
        var offset = Vector2(0.5 * (fan_radius - card_size.x), fan_radius)
        
        fit_child_in_rect(card, Rect2(Vector2(sin(angle), -cos(angle)) * fan_radius + offset,  card_size))
        card.rotation =  angle
        card.z_index = 0 


func add_card(card: Card) -> void:
    if get_child_count() == 10:
        _discard_card(card)
    else:
        card.card_entered.connect(_on_card_entered)
        card.card_exited.connect(_on_card_exited)
        add_child(card)


func pop_card() -> void:
    var count = get_child_count()
    for i in count:
        remove_child(get_child(i))
        return


func _on_sort_children() -> void:
    _arrange_cards()


func _on_card_entered(card: Card) -> void:
    if not active_card:
        active_card = card
        _start_hovering()
    else:
        next_candidate = card


func _on_card_exited(card: Card) -> void:
    if card == active_card and not is_dragging:
        active_card = null
        _arrange_cards()
    

func _on_gui_input(event: InputEvent) -> void:
    if not event is InputEventMouseButton or not active_card:
        return
    if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        is_dragging = true
    elif not event.pressed: # and is_dragging
        _stop_dragging(event.button_index != MOUSE_BUTTON_RIGHT)


## play is true if intent is to play a card, otherwise intent is to drop it
func _stop_dragging(play: bool) -> void:
    if active_card.global_position.y + active_card.size.y < global_position.y and play:
        _play_card(active_card)
        is_dragging = false
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


func _play_card(card) -> void:
    _discard_card(card)


func _discard_card(card: Card) -> void:
    card.queue_free()


func _is_hovering(card: Card) -> bool:
    var mp := get_global_mouse_position()
    return card.get_global_rect().has_point(mp) and mp.y <= get_viewport_rect().size.y


func _start_hovering() -> void:
    if is_dragging:
        return
    active_card.z_index = 1
    active_card.rotation = 0
    active_card.scale = HOVER_SCALE
    active_card.global_position.y = (
        get_viewport_rect().size.y
        - active_card.get_global_rect().size.y
    )

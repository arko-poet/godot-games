@tool
class_name Hand
extends Container

var cards : Array[Control] = []
var is_dragging := false

@export var max_angle: float = 18.0 ## maximum card spread
@export var card_size := Vector2(160, 225)
@export var angle_per_card := 3.0 ## ideal spread per card


func _ready():
	if Engine.is_editor_hint():
		queue_sort()


func _process(_delta):
	if Engine.is_editor_hint():
		queue_sort()


func _arrange_cards() -> void:
	var fan_radius := size.x

	var count = get_child_count()
	var total_angle = min(max_angle, angle_per_card * (count - 1))
	
	for i in count:
		var card: Control = get_child(i)
		card.z_index = 0
		var interpolation_weight = 0.5
		if count > 1:
			interpolation_weight = float(i) / (count - 1)
			
		var angle = deg_to_rad(lerp(-total_angle, total_angle, interpolation_weight))
			
		var offset = Vector2(0.5 * (fan_radius - card_size.x), fan_radius)
		fit_child_in_rect(card, Rect2(Vector2(sin(angle), -cos(angle)) * fan_radius + offset,  card_size))
		card.rotation =  angle


func _on_sort_children() -> void:
	_arrange_cards()


func add_card(card: Card) -> void:
	cards.append(card)
	card.card_discarded.connect(_discard_card)
	card.stopped_dragging.connect(_on_card_stopped_dragging)
	card.stopped_hovering.connect(_arrange_cards)
	add_child(card)


func remove_card(card: Card) -> void:
	cards.erase(card)


func pop_card() -> void:
	if not cards.is_empty():
		var card = cards.pop_at(0)
		card.queue_free()


func _get_minimum_size() -> Vector2:
	return card_size


func _discard_card(card: Card) -> void:
	cards.erase(card)
	card.queue_free()
	
func _on_card_stopped_dragging() -> void:
	is_dragging = false
	_arrange_cards()

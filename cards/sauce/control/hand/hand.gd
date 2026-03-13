@tool
class_name Hand
extends Container

var cards : Array[PanelContainer] = []

@export var max_angle: float = 18.0 ## maximum card spread
@export var radius: float = 1200.0 ## fan radius
@export var card_size := Vector2(160, 225)
@export var angle_per_card := 3.0 ## ideal spread per card


func _ready():
	if Engine.is_editor_hint():
		queue_sort()


func _arrange_cards() -> void:
	var count = get_child_count()
	var total_angle = min(max_angle, angle_per_card * (count - 1))
	for i in count:
		var card: PanelContainer = get_child(i)
		var interpolation_weight = 0.5
		if count > 1:
			interpolation_weight = float(i) / (count - 1)
			
		var angle = deg_to_rad(lerp(-total_angle, total_angle, interpolation_weight))
			
		fit_child_in_rect(card, Rect2(Vector2(sin(angle), -cos(angle)) * radius, card_size))
		card.rotation =  angle


func _on_sort_children() -> void:
	_arrange_cards()


func add_card(card: PanelContainer) -> void:
	cards.append(card)
	add_child(card)


func remove_card(card: PanelContainer) -> void:
	cards.erase(card)


func pop_card() -> void:
	if not cards.is_empty():
		var card = cards.pop_at(0)
		card.queue_free()

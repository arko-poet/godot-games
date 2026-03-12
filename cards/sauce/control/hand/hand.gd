@tool
extends Container

const CARD_SIZE := Vector2(160, 225)

@export var max_angle: float = 1200.0
@export var radius: float = 20.0


func _ready():
	if Engine.is_editor_hint():
		queue_sort()


func _arrange_cards() -> void:
	var count = get_child_count()
	if count == 0:
		return

	for i in count:
		var card: PanelContainer = get_child(i)

		var t = 0.5
		if count > 1:
			t = float(i) / (count - 1)

		var angle = lerp(-max_angle, max_angle, t)
		var rad = deg_to_rad(angle)

		var x = sin(rad) * radius
		var y = -cos(rad) * radius

		fit_child_in_rect(card, Rect2(Vector2(x, y), CARD_SIZE))
		card.rotation = rad


func _on_sort_children() -> void:
	_arrange_cards()

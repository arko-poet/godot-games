extends HBoxContainer

var default_card_scale: Vector2


func _on_sort_children() -> void:
	for c in get_children():
		c.scale = default_card_scale 


func _on_tree_entered() -> void:
	if get_parent() is CardChoice:
		default_card_scale = (get_parent() as CardChoice).DEFAULT_CARD_SCALE

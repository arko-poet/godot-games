extends Character


func _on_combat_finished() -> void:
	hp = max_hp


func _on_inventory_item_added(item: Item) -> void:
	_process_item_passive_effect(item, true)


func _on_inventory_item_removed(item: Item) -> void:
	_process_item_passive_effect(item, false)


func _process_item_passive_effect(item: Item, apply: bool) -> void:
	var passive_effect := item.get_passive_effect()
	var hp_increase: int = passive_effect.get("max_hp", 0)
	max_hp += hp_increase if apply else -hp_increase
	hp = max_hp

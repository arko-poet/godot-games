extends Character


func _on_combat_finished() -> void:
	hp = max_hp


func _on_inventory_item_added(item: Item) -> void:
	_process_item_passive_effect(item, true)


func _on_inventory_item_removed(item: Item) -> void:
	_process_item_passive_effect(item, false)


func _process_item_passive_effect(item: Item, apply: bool) -> void:
	print("yep")
	print(item.get_passive_effect())
	print(apply)
	var passive_effect := item.get_passive_effect()
	var hp_increase: int = passive_effect.get("max_hp", 0)
	print(max_hp)
	max_hp += hp_increase if apply else -hp_increase
	print(max_hp)
	hp = max_hp

class_name StorageComponent extends Node

const ItemScene := preload("res://scenes/item.tscn")

var _storage: Dictionary[Resources.Type, int]


func store_resources(resource_type: Resources.Type, quantity: int) -> void:
	if _storage.has(resource_type):
		_storage[resource_type] += quantity
	else:
		_storage[resource_type] = quantity


func store_item(item: Item) -> void:
	_storage[item.resource] = _storage.get(item.resource, 0) + 1
	item.queue_free()


func get_stored_item() -> Item:
	for resource in _storage:
		if _storage[resource] > 0:
			var item: Item = ItemScene.instantiate()
			item.resource = resource
			_storage[resource] -= 1
			return item
	
	push_error("Attempt to get stored item on empty storage")
	return null


func has_stored_items() -> bool:
	for resource in _storage:
		if _storage[resource] > 0:
			return true
	
	return false

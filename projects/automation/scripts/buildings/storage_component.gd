class_name StorageComponent
extends Node

const ItemScene := preload("res://scenes/item.tscn")

@export var allowed_deposits: Array[Resources.Type]
@export var allowed_withdrawals: Array[Resources.Type]

var _storage: Dictionary[Resources.Type, int]


func store_resources(resource_type: Resources.Type, quantity: int) -> bool:
	if not resource_type in allowed_deposits:
		return false

	if _storage.has(resource_type):
		_storage[resource_type] += quantity
	else:
		_storage[resource_type] = quantity
	return true


func store_item(item: Item) -> bool:
	if not item.resource in allowed_deposits:
		return false

	_storage[item.resource] = _storage.get(item.resource, 0) + 1
	item.queue_free()
	return true


func get_stored_item() -> Item:
	for resource in _storage:
		if _storage[resource] > 0 and resource in allowed_withdrawals:
			var item: Item = ItemScene.instantiate()
			item.resource = resource
			_storage[resource] -= 1
			return item

	push_error("Attempt to get stored item on empty storage")
	return null


func has_stored_items() -> bool:
	for resource in _storage:
		if _storage[resource] > 0 and resource in allowed_withdrawals:
			return true

	return false


func has_stored_resource(resource: Resources.Type) -> bool:
	return _storage.has(resource) and _storage[resource] > 0


func withdraw_stored_resource(resource: Resources.Type) -> bool:
	if has_stored_resource(resource) and resource in allowed_withdrawals:
		_storage[resource] -= 1
		return true
	return false

class_name TileResourceData extends RefCounted

signal depleted(tile_resource_data: TileResourceData)

enum ResourceType {
	COAL
}

var resource: ResourceType
var quantity: int:
	set(value):
		quantity = value
		if quantity == 0:
			depleted.emit(self)


func _init(p_resource: ResourceType, p_quantity: int = 5) -> void:
	resource = p_resource
	quantity = p_quantity


func get_name() -> String:
	return ResourceType.find_key(resource)


func mine() -> int:
	if quantity > 0:
		quantity -= 1
		return 1
	return 0

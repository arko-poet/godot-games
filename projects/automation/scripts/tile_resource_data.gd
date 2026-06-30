class_name TileResourceData extends RefCounted

enum ResourceType {
	COAL
}

var resource: ResourceType
var quantity: int


func _init(p_resource: ResourceType, p_quantity: int = 5) -> void:
	resource = p_resource
	quantity = p_quantity


func get_name() -> String:
	return ResourceType.find_key(resource)

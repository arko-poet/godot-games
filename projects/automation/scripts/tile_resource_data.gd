class_name TileResourceData extends RefCounted

enum ResourceType {
	COAL
}

var resource: ResourceType
var quantity: int
var name: String


func _init(p_resource: ResourceType, p_quantity: int = 100) -> void:
	resource = p_resource
	quantity = p_quantity


func get_name() -> String:
	return ResourceType.keys()[resource]

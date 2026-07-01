class_name ResourceNode extends RefCounted

signal depleted(tile_resource_data: ResourceNode)

var resource_type: Resources.Type
var quantity: int:
	set(value):
		quantity = value
		if quantity == 0:
			depleted.emit(self)


func _init(p_resource_type: Resources.Type, p_quantity: int = 5) -> void:
	resource_type = p_resource_type
	quantity = p_quantity


func mine() -> int:
	if quantity > 0:
		quantity -= 1
		return 1
	
	return 0

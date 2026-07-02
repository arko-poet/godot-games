extends Node

signal resource_changed(resource_type: Resources.Type, quantity: int)

var _coal: int:
	set(value):
		_coal = value
		resource_changed.emit(Resources.Type.COAL, _coal)

var _copper: int:
	set(value):
		_copper = value
		resource_changed.emit(Resources.Type.COPPER, _copper)


func _on_layers_resource_collected(type: Resources.Type, quantity: int) -> void:
	if type == Resources.Type.COAL:
		_coal += quantity
	else:
		_copper += quantity

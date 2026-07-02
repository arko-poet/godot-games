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

var _silver: int:
	set(value):
		_silver = value
		resource_changed.emit(Resources.Type.SILVER, _silver)

func _on_layers_resource_collected(type: Resources.Type, quantity: int) -> void:
	match type:
		Resources.Type.COAL:
			_coal += quantity
		Resources.Type.COPPER:
			_copper += quantity
		Resources.Type.SILVER:
			_silver += quantity
		_:
			push_error("Invalid Resource Type: %s" % type)

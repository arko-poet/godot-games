extends Node

signal coal_changed(coal: int)

var _coal: int:
	set(value):
		_coal = value
		coal_changed.emit(_coal)


func _on_layers_coal_collected(coal: int) -> void:
	_coal += coal

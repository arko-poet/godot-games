extends VBoxContainer

@onready var _coal_label: Label = %Coal
@onready var _copper_label: Label = %Copper


func _on_player_resources_resource_changed(resource_type: Resources.Type, quantity: int) -> void:
	if resource_type == Resources.Type.COAL:
		_coal_label.text = "Coal: %s" % quantity
	else:
		_copper_label.text = "Copper: %s" % quantity

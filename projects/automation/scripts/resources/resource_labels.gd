extends VBoxContainer

@onready var _coal_label: Label = %Coal
@onready var _copper_label: Label = %Copper
@onready var _silver_label: Label = %Silver

func _on_player_resources_resource_changed(resource_type: Resources.Type, quantity: int) -> void:
	match resource_type:
		Resources.Type.COAL:
			_coal_label.text = "Coal: %s" % quantity
		Resources.Type.COPPER:
			_copper_label.text = "Copper: %s" % quantity
		Resources.Type.SILVER:
			_silver_label.text = "Silver: %s" % quantity
		_:
			push_error("Invalid Resource.Type: %s" % resource_type)

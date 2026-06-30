extends VBoxContainer


var coal := 0:
	set(val):
		coal = val
		_coal_label.text = "Coal: %s" % coal
		
@onready var _coal_label: Label = %Coal


func _on_tile_map_layers_coal_collected() -> void:
	coal += 1

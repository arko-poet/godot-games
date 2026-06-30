extends VBoxContainer

@onready var camera: Camera2D = %Camera

@onready var position_label: Label = %Position
@onready var chunk_label: Label = %Chunk
@onready var hovered_resource: Label = %Resource


func _process(_delta: float) -> void:
	var x := camera.global_position.x + get_viewport_rect().size.x / 2
	var y := camera.global_position.y + get_viewport_rect().size.y / 2
	position_label.text = "camera position = (%d, %d)" % [x, y]
	chunk_label.text = "chunk = (%s, %s)" % [camera.chunk.x, camera.chunk.y]


func _on_tile_map_layers_resource_hovered(resource_data: TileResourceData) -> void:
	if resource_data:
		hovered_resource.text = "%s: %s" % [resource_data.get_name(), resource_data.quantity]
	else:
		hovered_resource.text = ""
	

extends VBoxContainer

@onready var _camera: Camera2D = %Camera

@onready var _position_label: Label = %Position
@onready var _chunk_label: Label = %Chunk
@onready var _hovered_resource_label: Label = %Resource


func _process(_delta: float) -> void:
	var x := _camera.global_position.x + get_viewport_rect().size.x / 2
	var y := _camera.global_position.y + get_viewport_rect().size.y / 2
	_position_label.text = "camera position = (%d, %d)" % [x, y]
	


func _on_tile_map_layers_resource_hovered(resource_node: ResourceNode) -> void:
	var text = ""
	if resource_node:
		text = "%s: %s" % [Resources.get_type_name(resource_node.resource_type), resource_node.quantity]
	_hovered_resource_label.text = text


func _on_camera_chunk_changed(chunk: Vector2i) -> void:
	_chunk_label.text = "chunk = (%s, %s)" % [chunk.x, chunk.y]

extends Node2D

@onready var resource_layer: TileMapLayer = %ResourceLayer

var chunks: Array[Image]
var queue: Array[Vector2i]

func _on_layers_chunk_generated(chunk: Vector2i) -> void:
	if not resource_layer:
		queue.append(chunk)
		return
	
	var image := Image.create(32, 32, false, Image.FORMAT_RGBA8)
	for i in 32:
		for j  in 32:
			var color: Color
			match resource_layer.get_cell_source_id(Vector2i(i + chunk.x * 32, j + chunk.y * 32)):
				0:
					color = Color.BLACK
				1:
					color = Color.ORANGE
				2:
					color = Color.WHITE
				_:
					color = Color.GREEN
					
			image.set_pixel(i, j, color)
	
	var sprite := Sprite2D.new()
	sprite.texture = ImageTexture.create_from_image(image)
	sprite.position = chunk * 32
	add_child(sprite)
	
	if not queue.is_empty():
		_on_layers_chunk_generated(queue.pop_front())

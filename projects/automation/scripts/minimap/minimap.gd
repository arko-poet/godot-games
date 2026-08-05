extends Node2D

const RESOURCE_TO_COLOR := {
	Resources.Type.COAL: Color.BLACK,
	Resources.Type.COPPER: Color.ORANGE,
	Resources.Type.SILVER: Color.WHITE,
}

var chunks: Array[Image]
## queue for drawing chunks (needed in case resource_layer is not set yet)
var queue: Array[Vector2i]

@onready var resource_layer: TileMapLayer = %ResourceLayer


func _ready() -> void:
	while not queue.is_empty():
		_on_layers_chunk_generated(queue.pop_back())


func _on_layers_chunk_generated(chunk: Vector2i) -> void:
	if not resource_layer:
		if chunk not in queue:
			queue.append(chunk)
		return

	var size := World.CHUNK_SIZE
	var image := Image.create(size, size, false, Image.FORMAT_RGBA8)
	for i in size:
		for j in size:
			var resource := resource_layer.get_cell_source_id(
				Vector2i(i + chunk.x * size, j + chunk.y * size)
			) as Resources.Type
			var color: Color = RESOURCE_TO_COLOR.get(resource, Color.GREEN)
			image.set_pixel(i, j, color)

	var sprite := Sprite2D.new()
	sprite.centered = false
	sprite.texture = ImageTexture.create_from_image(image)
	sprite.position = chunk * size
	add_child(sprite)

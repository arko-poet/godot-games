extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(tile_set)
	for i in 30:
		for j in 17:
			print(i)
			set_cell(Vector2(i, j), 0, Vector2.ZERO)
			pass

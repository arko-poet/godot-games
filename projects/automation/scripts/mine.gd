extends Node2D

const TILE_RANGE := 5

var storage: Dictionary[TileResourceData.ResourceType, int]

var tiles: Array[TileResourceData]


func set_tiles(p_tiles: Array[TileResourceData]) -> void:
	tiles = p_tiles
	for tile in tiles:
		tile.depleted.connect(_on_tile_depleted)


func _on_miner_timeout() -> void:
	var tile = tiles[randi() % tiles.size()]
	storage[tile.resourece] += tile.mine()


func _on_tile_depleted(tile: TileResourceData) -> void:
	tiles.erase(tile)

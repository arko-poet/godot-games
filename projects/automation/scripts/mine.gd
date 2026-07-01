class_name Mine extends Node2D

const TILE_RANGE := 2

var storage: Dictionary[TileResourceData.ResourceType, int]

var tiles: Array[TileResourceData]


func set_tiles(p_tiles: Array[TileResourceData]) -> void:
	tiles = p_tiles
	for tile in tiles:
		tile.depleted.connect(_on_tile_depleted)


func _on_miner_timeout() -> void:
	if tiles.size() == 0:
		return
	var tile = tiles[randi() % tiles.size()]
	if storage.has(tile.resource):
		storage[tile.resource] += tile.mine()
	else:
		storage[tile.resource] = tile.mine()


func _on_tile_depleted(tile: TileResourceData) -> void:
	tiles.erase(tile)

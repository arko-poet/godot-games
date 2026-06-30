class_name World extends Node2D

const CHUNK_SIZE := 32
const TILE_SIZE := 32

const BuildingPreview := preload("res://scenes/building_preview.tscn")


func _on_create_mine_pressed() -> void:
	var building_preview := BuildingPreview.instantiate()
	add_child(building_preview)

extends Node2D

@onready var building_component: BuildingComponent = $BuildingComponent
@onready var storage: StorageComponent = %Storage

func _on_building_component_timeout() -> void:
	pass # Replace with function body.

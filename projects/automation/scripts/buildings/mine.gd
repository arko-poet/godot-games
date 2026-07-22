class_name Mine extends Node2D

const TILE_RANGE := 2

var _resource_nodes: Array[ResourceNode]

@onready var building_component: BuildingComponent = $BuildingComponent
@onready var storage: StorageComponent = %Storage
@onready var sprite: Sprite2D = %Sprite
@onready var _production_timer: Timer = %ProductionTimer


func set_tiles(resource_nodes: Array[ResourceNode]) -> void:
	_resource_nodes = resource_nodes
	
	for resource_node in _resource_nodes:
		resource_node.depleted.connect(_on_resource_node_depleted)


func activate() ->  void:
	_production_timer.start()


func _on_resource_node_depleted(resource_node: ResourceNode) -> void:
	_resource_nodes.erase(resource_node)


func _on_production_timer_timeout() -> void:
	if _resource_nodes.size() == 0:
		return
	
	var resource_node := _resource_nodes[randi() % _resource_nodes.size()]
	var mined_resource_quantity := resource_node.mine()
	storage.store_resources(resource_node.resource_type, mined_resource_quantity)

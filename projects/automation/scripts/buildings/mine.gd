class_name Mine extends Node2D

const TILE_RANGE := 2

var storage: Dictionary[Resources.Type, int]

var _resource_nodes: Array[ResourceNode]

@onready var building_component: BuildingComponent = $BuildingComponent


func set_tiles(resource_nodes: Array[ResourceNode]) -> void:
	_resource_nodes = resource_nodes
	
	for resource_node in _resource_nodes:
		resource_node.depleted.connect(_on_resource_node_depleted)


func _on_resource_node_depleted(resource_node: ResourceNode) -> void:
	_resource_nodes.erase(resource_node)


func _on_building_component_timeout() -> void:
	if _resource_nodes.size() == 0:
		return
	
	var resource_node := _resource_nodes[randi() % _resource_nodes.size()]
	var mined_resource_quantity := resource_node.mine()
	if storage.has(resource_node.resource_type):
		storage[resource_node.resource_type] += mined_resource_quantity
	else:
		storage[resource_node.resource_type] = mined_resource_quantity

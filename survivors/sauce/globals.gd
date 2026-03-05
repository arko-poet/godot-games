extends Node


func find_nearest_enemy(position: Vector2) -> Node2D:
	var nearest_enemy: Node2D = null
	var nearest_distance: float
	for e in get_tree().get_nodes_in_group("monsters"):
		if not nearest_enemy:
			nearest_enemy = e
			nearest_distance = position.distance_squared_to(e.global_position)
			continue
		var e_distance = position.distance_squared_to(e.global_position)
		if e_distance < nearest_distance:
			nearest_enemy = e
			nearest_distance = e_distance
	return nearest_enemy

extends Area2D

var damage: int

var monsters: Array[Monster] = []


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("monsters"):
		monsters.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("monsters"):
		monsters.erase(body)


func _on_damage_timer_timeout() -> void:
	for monster in monsters:
		monster.hit(damage)


func _on_ttl_timeout() -> void:
	queue_free()

extends Item

@export_range(1, 100) var max_hp: int


func get_passive_effect() -> Dictionary:
	return {"max_hp": max_hp}


func _set_footprints() -> void:
	footprints.append([Vector2i.ZERO])
	
	
func _set_rotation_offsets() -> void:
	rotation_offsets.append(Vector2i.ZERO)
	

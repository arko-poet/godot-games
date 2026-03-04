extends Node2D

const FireStaff := preload("res://sauce/fire_staff.tscn")
const Sword := preload("res://sauce/sword.tscn")
const Chakrams := preload("res://sauce/chakrams.tscn")
var weapons : Array[Weapon] = []


func _ready() -> void:
	var fire_staff : Weapon = FireStaff.instantiate()
	fire_staff.projectile_root = get_parent().get_parent() 
	add_child(fire_staff)
	weapons.append(fire_staff)

	var sword : Weapon = Sword.instantiate()
	sword.projectile_root = get_parent().get_parent() 
	add_child(sword)
	weapons.append(sword)

	var chakrams : Weapon = Chakrams.instantiate()
	chakrams.projectile_root = get_parent().get_parent() 
	add_child(chakrams)
	weapons.append(chakrams)

func _process(_delta : float) -> void:
	var target : Node2D = _find_nearest_enemy()
	if target:
		for weapon in weapons:
			weapon.target = target.global_position


func _find_nearest_enemy() -> Node2D:
	var nearest_enemy : Node2D = null
	var nearest_distance : float
	for e in get_tree().get_nodes_in_group("monsters"):
		if not nearest_enemy:
			nearest_enemy = e
			nearest_distance = global_position.distance_squared_to(e.global_position)
			continue
		var e_distance = global_position.distance_squared_to(e.global_position)
		if e_distance < nearest_distance:
			nearest_enemy = e
			nearest_distance = e_distance
	return nearest_enemy

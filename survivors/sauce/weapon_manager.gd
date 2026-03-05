extends Node2D

enum WeaponID {FIRE_STAFF, SWORD, CHAKRAMS, SPEARS}
const WEAPON_SCENES := {
	WeaponID.FIRE_STAFF : preload("res://sauce/fire_staff.tscn"),
	WeaponID.SWORD : preload("res://sauce/sword.tscn"),
	WeaponID.CHAKRAMS : preload("res://sauce/chakrams.tscn"),
	WeaponID.SPEARS: preload("res://sauce/spears.tscn"),
}
var weapons : Array[Weapon] = []


func _ready() -> void:
	#add_weapon(WeaponID.FIRE_STAFF)
	#add_weapon(WeaponID.SWORD)
	#add_weapon(WeaponID.CHAKRAMS)
	add_weapon(WeaponID.SPEARS)


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


func add_weapon(weapon_id : WeaponID) -> void:
	var weapon_scene : PackedScene = WEAPON_SCENES[weapon_id]
	if weapon_scene != null:
		var weapon : Weapon = weapon_scene.instantiate()
		weapon.projectile_root = get_parent().get_parent() 
		add_child(weapon)
		weapons.append(weapon)
	else:
		push_error("invalid weapon_id: %s" % weapon_id)

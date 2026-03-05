extends Node2D

enum WeaponID {BALLS, SWORD, CHAKRAMS, SPEARS}
const WEAPON_SCENES := {
	WeaponID.BALLS : preload("res://sauce/balls.tscn"),
	WeaponID.SWORD : preload("res://sauce/sword.tscn"),
	WeaponID.CHAKRAMS : preload("res://sauce/chakrams.tscn"),
	WeaponID.SPEARS: preload("res://sauce/spears.tscn"),
}
var weapons : Array[Weapon] = []


func _ready() -> void:
	add_weapon(WeaponID.BALLS)
	#add_weapon(WeaponID.SWORD)
	#add_weapon(WeaponID.CHAKRAMS)
	#add_weapon(WeaponID.SPEARS)


func add_weapon(weapon_id : WeaponID) -> void:
	var weapon_scene : PackedScene = WEAPON_SCENES[weapon_id]
	if weapon_scene != null:
		var weapon : Weapon = weapon_scene.instantiate()
		weapon.projectile_root = get_parent().get_parent() 
		add_child(weapon)
		weapons.append(weapon)
	else:
		push_error("invalid weapon_id: %s" % weapon_id)

class_name UpgradeService
extends Node

enum WeaponID {BALLS, SWORD, CHAKRAMS, SPEARS, BOUNCERS, FIRE_STAFF, TOXIC_VIALS}

const WEAPON_SCENES := {
	WeaponID.BALLS: preload("res://sauce/weapons/balls/balls.tscn"),
	WeaponID.SWORD: preload("res://sauce/weapons/sword/sword.tscn"),
	WeaponID.CHAKRAMS: preload("res://sauce/weapons/chakrams/chakrams.tscn"),
	WeaponID.SPEARS: preload("res://sauce/weapons/spears/spears.tscn"),
	WeaponID.BOUNCERS: preload("res://sauce/weapons/bouncers/bouncers.tscn"),
	WeaponID.FIRE_STAFF: preload("res://sauce/weapons/fire_staff/fire_staff.tscn"),
	WeaponID.TOXIC_VIALS: preload("res://sauce/weapons/toxic_weapon/toxic_vials.tscn")
}


func get_upgrades(player: Player) -> void:
	print("getting upgrades")


func _new_weapon(weapon_id: WeaponID) -> Weapon:
	var weapon_scene: PackedScene = WEAPON_SCENES[weapon_id]
	if weapon_scene != null:
		var weapon: Weapon = weapon_scene.instantiate()
		return weapon
		
	push_error("invalid weapon_id: %s" % weapon_id)
	return null

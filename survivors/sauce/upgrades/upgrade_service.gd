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
const WEAPON_NAMES := {
	WeaponID.BALLS: "Balls",
	WeaponID.SWORD: "Sword",
	WeaponID.CHAKRAMS: "Chakrams",
	WeaponID.SPEARS: "Spears",
	WeaponID.BOUNCERS: "Bouncers",
	WeaponID.FIRE_STAFF: "Fire Staff",
	WeaponID.TOXIC_VIALS: "Toxic Vials"
}


func get_upgrades(player: Player) -> Array[Upgrade]:
	var player_weapon_ids : Array[int]
	for weapon in player.weapons:
		player_weapon_ids.append(weapon.id)
	
	var weapon_pool = WeaponID.values().duplicate()
	weapon_pool.shuffle()
	var weapon_picks = weapon_pool.slice(0, 3)
	
	var upgrades : Array[Upgrade] = []
	for weapon_id in weapon_picks:
		var upgrade := Upgrade.new()
		upgrade.name_ = WEAPON_NAMES[weapon_id]
		upgrade.id = weapon_id
		if weapon_id in player_weapon_ids:
			upgrade.property = "damage"
			upgrade.value = 1.0
		upgrades.append(upgrade)
	return upgrades


func execute_upgrade(upgrade: Upgrade, player: Player) -> void:
	var weapon = _new_weapon(upgrade.id)
	if upgrade.property:
		weapon.damage += int(upgrade.value)
	else:
		player.add_weapon(weapon)


func _new_weapon(weapon_id: WeaponID) -> Weapon:
	var weapon_scene: PackedScene = WEAPON_SCENES[weapon_id]
	if weapon_scene != null:
		var weapon: Weapon = weapon_scene.instantiate()
		weapon.id = weapon_id
		return weapon
		
	push_error("invalid weapon_id: %s" % weapon_id)
	return null

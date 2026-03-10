class_name UpgradeService
extends Node

enum WeaponID {BALLS, SWORD, CHAKRAMS, SPEARS, BOUNCERS, FIRE_STAFF, TOXIC_VIALS}
enum Rarity {COMMON, RARE, EPIC, LEGENDARY} 

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
const RARITY_WEIGHTS := {
	Rarity.COMMON: 69,
	Rarity.RARE: 25,
	Rarity.EPIC: 5,
	Rarity.LEGENDARY: 1
}
const RARITY_MULTIPLIERS := {
	Rarity.COMMON: 1.0,
	Rarity.RARE: 1.5,
	Rarity.EPIC: 2.0,
	Rarity.LEGENDARY: 3.0
}

func get_upgrades(player: Player) -> Array[Upgrade]:
	var player_weapon_ids : Array[int]
	for weapon in player.weapons:
		player_weapon_ids.append(weapon.id)
	
	# get 3 random items to upgrade
	var weapon_pool = WeaponID.values().duplicate()
	weapon_pool.shuffle()
	var weapon_picks = weapon_pool.slice(0, 3)
	
	# create upgrade objects
	var upgrades : Array[Upgrade] = []
	for weapon_id in weapon_picks:
		var upgrade := Upgrade.new()
		upgrade.name_ = WEAPON_NAMES[weapon_id]
		upgrade.id = weapon_id
		upgrade.rarity = Rarity.COMMON
		if weapon_id in player_weapon_ids:
			# random weapon property
			var weapon: Weapon = player.get_weapon(weapon_id)
			var property_pool = weapon.scalings.keys().duplicate()
			property_pool.shuffle()
			var property = property_pool[0]
			
			upgrade.property = property
			var rarity := _get_rarity()
			upgrade.value = weapon.scalings[property] * RARITY_MULTIPLIERS[rarity]
			upgrade.rarity = rarity
		upgrades.append(upgrade)
	return upgrades


func execute_upgrade(upgrade: Upgrade, player: Player) -> void:
	var weapon: Weapon
	if upgrade.property:
		weapon = player.get_weapon(upgrade.id)
		weapon.scalers[upgrade.property].call(upgrade.value)
	else:
		weapon = _new_weapon(upgrade.id)
		player.add_weapon(weapon)


func _new_weapon(weapon_id: WeaponID) -> Weapon:
	var weapon_scene: PackedScene = WEAPON_SCENES[weapon_id]
	if weapon_scene != null:
		var weapon: Weapon = weapon_scene.instantiate()
		weapon.id = weapon_id
		return weapon
		
	push_error("invalid weapon_id: %s" % weapon_id)
	return null


func _get_rarity() -> Rarity:
	var total_weight = 0
	for weight in RARITY_WEIGHTS.values():
		total_weight += weight
	var r = randi() % total_weight
	var cumulative = 0
	for rarity in RARITY_WEIGHTS:
		var weight = RARITY_WEIGHTS[rarity]
		cumulative += weight
		if r < cumulative:
			print("rarity = %s" % rarity)
			return rarity
	
	push_error("Error generating random rarity")
	return Rarity.COMMON

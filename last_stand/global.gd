extends Node

const LEVEL_RESOURCES := 12


var level : int
var zombies_killed : int
var health : int
var resources : int
var number_of_projectiles : int
var upgrade_weapon_progress : int
var projectile_damage : int
var max_zombies : int
var upgrade_weapon_cost : int
var cast_speed : float
var spawn_rate : float


func new_game() -> void:
	level = 1
	zombies_killed = 0
	health = 100
	resources = LEVEL_RESOURCES
	number_of_projectiles = 1
	upgrade_weapon_progress = 0
	projectile_damage = 1
	cast_speed = 0.5
	max_zombies = 8
	spawn_rate = 1.5
	upgrade_weapon_cost = 6

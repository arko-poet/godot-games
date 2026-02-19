extends Node


const MAX_ZOMBIES := 2
const LEVEL_RESOURCES := 10
const UPGRADE_WEAPON_COST := 6

var level := 1
var zombies_killed := 0
var health := 100
var resources := LEVEL_RESOURCES
var number_of_projectiles := 1
var upgrade_weapon_progress := 0
var projectile_damage := 1
var cast_speed := 0.5

class_name Weapon
extends Node2D

@export_range(0, 9999) var base_damage: int = 10
@export_range(0.0, 1.0) var damage_scaling: float = 0.5
@export_range(0.0, 1.0) var size_scaling: float = 0.2
@export_range(0.0, 1.0) var cooldown_scaling: float = 0.05

var damage_multiplier := 1.0
var size_multiplier := 1.0
var cooldown_multiplier := 1.0
var projectile_root: Node2D ## reference where weapon creates projectiles, e.g. World
var target: Node2D
var id: int ## weapon type, not unique identifier
var scalings: Dictionary = {}
var scalers: Dictionary = {
	"damage": scale_damage
	#"cooldown": scale_cooldown,
	#"size": scale_size
}

@onready var cooldown_timer: Timer = $CooldownTimer


func _ready() -> void:
	scalings["damage"] = damage_scaling
	#scalings["size"] = size_scaling
	#scalings["cooldown"] = cooldown_scaling


func _on_cooldown_timer_timeout() -> void:
	target = Globals.find_nearest_enemy(global_position)
	_attack()


func _attack() -> void:
	push_error("_attack() call on Weapon interface")


func scale_damage(val: float) -> void:
	damage_multiplier += val


func scale_cooldown(val: float) -> void:
	cooldown_multiplier += val
	
	
func scale_size(val: float) -> void:
	size_multiplier += val

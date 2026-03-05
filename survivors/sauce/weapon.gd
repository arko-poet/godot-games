class_name Weapon
extends Node2D

@export_range(0, 9999) var damage : int = 1
var projectile_root : Node2D ## reference where weapon creates projectiles
var target : Node2D
@onready var cooldown_timer: Timer = $CooldownTimer


func _on_cooldown_timer_timeout() -> void:
	target = Globals.find_nearest_enemy(global_position)
	_attack()


func _attack() -> void:
	push_error("_attack() call on Weapon interface")

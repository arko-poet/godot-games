class_name Weapon
extends Node2D

var projectile_root : Node2D ## reference where weapon creates projectiles
var target : Vector2
@onready var cooldown_timer: Timer = $CooldownTimer


func _on_cooldown_timer_timeout() -> void:
	_attack()


func _attack() -> void:
	push_error("_attack() call on Weapon interface")

extends Node2D

const FireStaff := preload("res://sauce/fire_staff.tscn")
var weapons : Array[Weapon] = []


func _ready() -> void:
	var fire_staff : Weapon = FireStaff.instantiate()
	fire_staff.projectile_root = get_parent().get_parent() 
	add_child(fire_staff)
	weapons.append(fire_staff)

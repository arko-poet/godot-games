extends Node


const ZOMBIE_SCENE := preload("res://zombie.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var crosshair : Image = load("res://sprites/crosshair/crosshair.png").get_image()
	crosshair.resize(24, 24)
	Input.set_custom_mouse_cursor(crosshair)


func _on_zombie_spawner_timeout() -> void:
	var zombie: Zombie = ZOMBIE_SCENE.instantiate()
	$ZombieSpawnPath/ZombieSpawnLocation.progress_ratio = randf()
	zombie.position = $ZombieSpawnPath/ZombieSpawnLocation.position
 
	add_child(zombie)

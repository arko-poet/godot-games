extends Node


const ZOMBIE_SCENE := preload("res://zombie.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(load("res://sprites/crosshair/crosshair.png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_zombie_spawner_timeout() -> void:
	var zombie: Zombie = ZOMBIE_SCENE.instantiate()
	$ZombieSpawnPath/ZombieSpawnLocation.progress_ratio = randf()
	zombie.position = $ZombieSpawnPath/ZombieSpawnLocation.position
 
	add_child(zombie)

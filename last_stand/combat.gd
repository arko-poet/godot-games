extends Node

var spawned_zombies := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var crosshair : Image = load("res://sprites/crosshair/crosshair.png").get_image()
	crosshair.resize(24, 24)
	Input.set_custom_mouse_cursor(crosshair)

	$ZombieTimer.wait_time = Global.spawn_rate * pow(0.9, (Global.level - 1)) + 0.1

func _process(_delta) -> void:
	$VBoxContainer/BarricadeLabel.text = "Barricade: %s" % Global.health
	
	$VBoxContainer/LevelLabel.text = "Level: %s" % Global.level
	$VBoxContainer/ZombiesKilledLabel.text = "Zombies Killed: %s" % Global.zombies_killed

func _on_zombie_spawner_timeout() -> void:
	if spawned_zombies < Global.max_zombies:
		var zombie_type := (randi() % 4) + 1
		var zombie_scene := load("res://zombie%s.tscn" % zombie_type)
		var zombie: Zombie = zombie_scene.instantiate()
		zombie.set_type(zombie_type)
		$ZombieSpawnPath/ZombieSpawnLocation.progress_ratio = randf()
		zombie.position = $ZombieSpawnPath/ZombieSpawnLocation.position
		add_child(zombie)
		spawned_zombies += 1

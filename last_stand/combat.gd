extends Node

const ZOMBIE_SCENE := preload("res://zombie.tscn")

var spawned_zombies := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var crosshair : Image = load("res://sprites/crosshair/crosshair.png").get_image()
	crosshair.resize(24, 24)
	Input.set_custom_mouse_cursor(crosshair)


func _process(_delta) -> void:
	var barricade_life := 0
	if $Barricade:
		barricade_life = $Barricade.health
	$VBoxContainer/BarricadeLabel.text = "Barricade: %s" % barricade_life
	
	$VBoxContainer/LevelLabel.text = "Level: %s" % Global.level
	$VBoxContainer/ZombiesKilledLabel.text = "Zombies Killed: %s" % Global.zombies_killed

func _on_zombie_spawner_timeout() -> void:
	print(spawned_zombies)
	if spawned_zombies < Global.MAX_ZOMBIES:
		var zombie: Zombie = ZOMBIE_SCENE.instantiate()
		$ZombieSpawnPath/ZombieSpawnLocation.progress_ratio = randf()
		zombie.position = $ZombieSpawnPath/ZombieSpawnLocation.position
		add_child(zombie)
		spawned_zombies += 1

extends Node

## TODO increase zombie spawn timer
## TODO increase increse number of zombies to kill
## TODO add win and loose conditions
## TODO make combat scene look good
## TODO different zombies different properties
func _ready() -> void:
	$UpgradeScreen.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.zombies_killed == Global.max_zombies:
		$Combat.free()
		$UpgradeScreen.show()
		Global.zombies_killed = 0


func _on_upgrade_screen_next_level() -> void:
	Global.level += 1
	Global.max_zombies += 10
	$UpgradeScreen.hide()
	add_child(load("res://combat.tscn").instantiate())
	Global.resources = Global.LEVEL_RESOURCES

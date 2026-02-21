extends Node

const COMBAT_SCENE := preload("res://combat.tscn")

var combat : Combat


## TODO clean code comments etc
## TODO win condition
## TODO balance game
func _ready() -> void:
	Global.new_game()
	$UpgradeScreen.hide()
	$GameOver.hide()
	combat = COMBAT_SCENE.instantiate()
	add_child(combat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.health == 0:
		combat.queue_free()
		$GameOver.show()
		Global.new_game()
		
	
	if Global.zombies_killed == Global.max_zombies:
		combat.free()
		$UpgradeScreen.show()
		Global.zombies_killed = 0


func _on_upgrade_screen_next_level() -> void:
	Global.level += 1
	Global.max_zombies += 10
	$UpgradeScreen.hide()
	combat = COMBAT_SCENE.instantiate()
	add_child(combat)
	Global.resources = Global.LEVEL_RESOURCES


func _on_game_over_start_new_game() -> void:
	combat = COMBAT_SCENE.instantiate()
	add_child(combat)
	$GameOver.hide()

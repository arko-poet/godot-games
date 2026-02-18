extends Node


func _ready() -> void:
	$UpgradeScreen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.zombies_killed == Global.MAX_ZOMBIES:
		$Combat.free()
		$UpgradeScreen.show()
		Global.zombies_killed = 0


func _on_upgrade_screen_next_level() -> void:
	$UpgradeScreen.hide()
	add_child(load("res://combat.tscn").instantiate())

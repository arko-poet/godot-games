extends Control


signal next_level


func _process(_delta) -> void:
	$BarricadeHealth.text = "Barricade: %s" % Global.health
	$Resources.text = str(Global.resources)


func _on_next_level_pressed() -> void:
	next_level.emit()


func _on_upgrade_barricade_pressed() -> void:
	if Global.resources > 0:
		Global.resources -= 1
		Global.health += 10

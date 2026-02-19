extends Control


signal next_level


func _process(_delta) -> void:
	$BarricadeHealth.text = "Barricade: %s" % Global.health
	$Resources.text = str(Global.resources)
	$VBoxContainer2/ProgressBar.value = Global.upgrade_weapon_progress


func _on_next_level_pressed() -> void:
	next_level.emit()


func _on_upgrade_barricade_pressed() -> void:
	if Global.resources > 0:
		Global.resources -= 1
		Global.health += 10


func _on_upgrade_weapon_pressed() -> void:
	if Global.resources > 0:
		Global.resources -= 1
		if Global.upgrade_weapon_progress < 5:
			Global.upgrade_weapon_progress += 1
		else:
			Global.upgrade_weapon_progress = 0
			if Global.number_of_projectiles < Global.projectile_damage:
				Global.number_of_projectiles += 1
			else:
				Global.projectile_damage += 1

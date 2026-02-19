extends Control


signal next_level


func _process(_delta) -> void:
	$BarricadeHealth.text = str(Global.health)


func _on_next_level_pressed() -> void:
	next_level.emit()


func _on_upgrade_barricade_pressed() -> void:
	Global.health += 10

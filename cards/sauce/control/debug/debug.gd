extends VBoxContainer

var ui: UI


func _on_add_hp_button_pressed() -> void:
	ui.hp += 1


func _on_remove_hp_button_pressed() -> void:
	ui.hp -= 1


func _on_add_mana_button_pressed() -> void:
	ui.mana += 1


func _on_remove_mana_button_pressed() -> void:
	ui.mana -= 1


func _on_draw_card_button_pressed() -> void:
	ui.draw_card()

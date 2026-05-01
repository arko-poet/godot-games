class_name PerkButton
extends Button

var cost : int
var factor: float
var operation: String
var target
var property : String

signal purchase_perk(perk_button: PerkButton)


func _on_pressed() -> void:
	purchase_perk.emit(self)

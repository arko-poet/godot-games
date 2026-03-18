extends Control

const CardScene := preload("res://sauce/control/card/card.tscn")

@onready var hand: Hand = $Hand


func _on_add_card_button_pressed() -> void:
	var card: Card = CardScene.instantiate()
	card.mouse_entered.connect(_on_mouse_entered)
	hand.add_card(card)


func _on_remove_card_button_pressed() -> void:
	hand.pop_card()


func _on_mouse_entered() -> void:
	pass

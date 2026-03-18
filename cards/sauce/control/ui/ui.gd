extends Control

const CardScene := preload("res://sauce/control/card/card.tscn")

const MAX_HP := 100
const MAX_MANA := 3

var card_data: Dictionary
var hp: int:
	set(value):
		hp = value
		hp_label.text = "%s/%s" % [hp, MAX_HP]
var mana: int:
	set(value):
		mana = value
		mana_label.text = "%s/%s" % [mana, MAX_MANA]

@onready var hand: Hand = $Hand
@onready var hp_label: Label = $PlayerStatsBox/HPLabel
@onready var mana_label: Label = $PlayerStatsBox/ManaLabel


func _ready() -> void:
	hp = MAX_HP
	mana = MAX_MANA
	card_data = load("res://sauce/control/card/cards.json").get_data()


func _on_add_card_button_pressed() -> void:
	var card: Card = CardScene.instantiate()
	card.set_card_properties(card_data["Bozo Attack"])
	hand.add_card(card)


func _on_remove_card_button_pressed() -> void:
	hand.pop_card()


func _on_add_hp_button_pressed() -> void:
	hp += 1


func _on_remove_hp_button_pressed() -> void:
	hp -= 1


func _on_add_mana_button_pressed() -> void:
	mana += 1


func _on_remove_mana_button_pressed() -> void:
	mana -= 1

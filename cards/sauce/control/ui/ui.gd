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


func _on_hand_card_played(card: Card) -> void:
	_execute_card_actions(card)
	_discard_card(card)


func _discard_card(card: Card) -> void:
	# TODO implement discard pile
	card.queue_free()
	
func _execute_card_actions(card: Card) -> void:
	var actions = card.actions
	for action in actions:
		match action:
			"attack":
				_attack(int(actions[action]["value"]))
			_:
				push_error("unknown action type: %s" % action)


func _on_hand_card_discarded(card: Card) -> void:
	# TODO implement discard pile
	card.queue_free()


func _attack(damage: int):
	# TODO implement attacking
	print("attack for %s" % damage)

class_name GameRun
extends Control

signal player_died

const CardScene := preload("res://sauce/control/card/card.tscn")

const MAX_HP := 100
const MAX_MANA := 3
const STARTING_HAND_SIZE := 5
const CARD_CHOICE_SIZE := 3

var card_data: Dictionary
var deck: Array[Card] = []
var hp: int:
	set(value):
		hp = max(0, value)
		hp_label.text = "%s/%s" % [hp, MAX_HP]
		if hp == 0:
			player_died.emit()


@onready var hp_label: Label = $HPLabel
@onready var debug: VBoxContainer = $Debug
@onready var card_choice: CardChoice = $CardChoice
@onready var combat_encounter: CombatEncounter = $CombatEncounter
@onready var deck_label: Label = $DeckLabel


func _ready() -> void:
	hp = MAX_HP
	card_data = load("res://sauce/control/card/cards.json").get_data()
	combat_encounter.game_run = self
	_starter_deck()
	_next_encounter()

	debug.game_run = self

func combat_finished() -> void:
	# TODO hide/darken background
	_choose_cards()


func _starter_deck() -> void:
	for i in range(6):
		var card: Card = CardScene.instantiate()
		card.set_card_properties(card_data["Bozo Attack"])
		_add_card(card)
	
	for i in range(6):
		var card: Card = CardScene.instantiate()
		card.set_card_properties(card_data["Bozo Block"])
		_add_card(card)


func _next_encounter() -> void:
	combat_encounter.new_encounter(100)


func _on_card_choice_card_chosen(card: Card) -> void:
	assert(card)
	if card:
		print("hello?")
		_add_card(card)
		
	card_choice.hide()
	_next_encounter()


func _choose_cards() -> void:
	# TODO prevent hand from interacting 
	var card_keys = card_data.keys()
	card_keys.shuffle()
	var cards: Array[Card] = []
	for i in range(CARD_CHOICE_SIZE):
		var card: Card = CardScene.instantiate()
		card.set_card_properties(card_data[card_keys[i]])
		cards.append(card)
	card_choice.new_card_choice(cards)
	card_choice.show()


func _add_card(card: Card) -> void:
	print("_add_card()")
	assert(card)
	deck.append(card)
	_update_deck_label()

func _update_deck_label() -> void:
	deck_label.text = "%s" % deck.size()
	

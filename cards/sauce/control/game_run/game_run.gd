class_name GameRun
extends Control

signal player_died
signal rewards_claimed

const CardScene := preload("res://sauce/control/card/card.tscn")

const MAX_MANA := 3
const STARTING_HAND_SIZE := 5
const CARD_CHOICE_SIZE := 3
const STARTING_MAX_HP := 100

var max_hp: int:
	set(value):
		max_hp = value
		_update_hp_label()
var card_data: Dictionary
var hp: int:
	set(value):
		hp = max(0, min(value, max_hp))
		_update_hp_label()
		if hp == 0:
			player_died.emit()
var encounter_num := 1:
	set(value):
		encounter_num = value
		encounter_label.text = "Encounter: %s" % encounter_num

@onready var hp_label: Label = $HBoxContainer/HPLabel
@onready var debug: VBoxContainer = $Debug
@onready var card_choice: CardChoice = $CardChoice
@onready var combat_encounter: CombatEncounter = $CombatEncounter
@onready var deck_label: Button = $DeckLabel
@onready var deck: Deck = $Deck
@onready var encounter_label: Label = $HBoxContainer/EncounterLabel


func _ready() -> void:
	max_hp = STARTING_MAX_HP
	hp = max_hp
	card_data = load("res://sauce/control/card/cards.json").get_data()
	combat_encounter.game_run = self
	_starter_deck()

	debug.game_run = self


func combat_finished() -> void:
	# TODO hide/darken background
	_choose_cards()


func _starter_deck() -> void:
	for i in range(6):
		var card: Card = CardScene.instantiate()
		card.properties = card_data["Bozo Attack"]
		_add_card(card)
	
	for i in range(6):
		var card: Card = CardScene.instantiate()
		card.properties = card_data["Bozo Block"]
		_add_card(card)


func next_encounter(monster: Monster) -> void:
	combat_encounter.new_encounter(monster)
	encounter_num += 1


func _on_card_choice_card_chosen(card: Card) -> void:
	if card:
		_add_card(card)
		
	card_choice.hide()
	combat_encounter.turn_dimmer(false)
	rewards_claimed.emit()


func _choose_cards() -> void:
	# TODO prevent hand from interacting 
	var card_keys = card_data.keys()
	card_keys.shuffle()
	var cards: Array[Card] = []
	for i in range(CARD_CHOICE_SIZE):
		var card: Card = CardScene.instantiate()
		card.properties = card_data[card_keys[i]]
		cards.append(card)
	card_choice.new_card_choice(cards)
	card_choice.show()
	combat_encounter.turn_dimmer(true)


func _add_card(card: Card) -> void:
	assert(card)
	deck.add_card(card)
	_update_deck_label()


func _update_deck_label() -> void:
	deck_label.text = "DECK: %s" % deck.card_container.get_children().size()
	

func _on_deck_label_pressed() -> void:
	if deck.visible:
		deck.hide()
		combat_encounter.turn_dimmer(false)
	else:
		deck.show()
		combat_encounter.turn_dimmer(true)


func _update_hp_label() -> void:
	hp_label.text = "%s/%s" % [hp, max_hp]

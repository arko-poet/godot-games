class_name Deck
extends ScrollContainer

@onready var card_container: GridContainer = $CardContainer


func add_card(card: Card) -> void:
	card_container.add_child(card)


func get_card_copies() -> Array[Card]:
	var cards: Array[Card] = []
	for c in card_container.get_children():
		if c is Card:
			var dup = c.duplicate()
			dup.properties = c.properties
			cards.append(dup)
	return cards

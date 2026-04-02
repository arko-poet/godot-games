class_name Deck
extends ScrollContainer

@onready var card_container: GridContainer = $CenterContainer/CardContainer


func add_card(card: Card) -> void:
	card_container.add_child(card)


## cards are duplicated when they are drawn, so that the player can view deck at any time
func get_card_copies() -> Array[Card]:
	var cards: Array[Card] = []
	for c in card_container.get_children():
		if c is Card:
			var dup = c.duplicate()
			dup.default_properties = c.default_properties
			cards.append(dup)
	return cards

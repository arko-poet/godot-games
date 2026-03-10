extends Control

signal upgrade_chosen(upgrade: Upgrade)

var selected_card := 1
var arrow_bob_switch := false ## arrow bob left or right

@onready var cards := {
	1: $MainPanel/UpgradeCards/Card1,
	2: $MainPanel/UpgradeCards/Card2,
	3: $MainPanel/UpgradeCards/Card3
}
@onready var left_arrow: TextureRect = $LeftArrow
@onready var right_arrow: TextureRect = $RightArrow


func _ready() -> void:
	await get_tree().process_frame
	_set_arrow_position()


func set_upgrades(upgrades):
	cards[1].set_upgrade(upgrades[0])
	cards[2].set_upgrade(upgrades[1])
	cards[3].set_upgrade(upgrades[2])


func _set_arrow_position() -> void:
	var card : PanelContainer = cards[selected_card]
	if not card:
		push_error("invalid slected_card index: %s" % selected_card)
		return
	var y = card.global_position.y + 0.5 * (card.size.y - left_arrow.size.y)
	left_arrow.global_position.y = y
	right_arrow.global_position.y = y

func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("ui_up"):
		selected_card = (selected_card + 1) % 3 + 1
		_set_arrow_position()
	elif event.is_action_pressed("ui_down"):
		selected_card = 1 + selected_card % 3
		_set_arrow_position()
	elif event.is_action_pressed("ui_accept"):
		emit_signal("upgrade_chosen", cards[selected_card].upgrade)


func _on_arrow_animation_timer_timeout() -> void:
	if arrow_bob_switch:
		left_arrow.global_position.x += 2
		right_arrow.global_position.x -= 2
	else:
		left_arrow.global_position.x -= 2
		right_arrow.global_position.x += 2
	arrow_bob_switch = not arrow_bob_switch

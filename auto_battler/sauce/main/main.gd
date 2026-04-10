extends Node

const Stone := preload("res://sauce/items/stone/stone.tscn")

const DRAG_CURSOR := preload(
	"res://assets/kenney_cursor-pack/PNG/Outline/Default/hand_closed.png"
)
const HOVER_CURSOR := preload(
	"res://assets/kenney_cursor-pack/PNG/Outline/Default/gauntlet_point.png"
)
const NEW_ITEM_POSITION := Vector2i(82, 1)

@onready var ui: Control = $UILayer/UI


func _ready() -> void:
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_DRAG)
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(HOVER_CURSOR, Input.CURSOR_POINTING_HAND)


func _on_player_died() -> void:
	get_tree().reload_current_scene()


func _on_combat_finished() -> void:
	#TODO choose random item here instead
	var item := Stone.instantiate()
	item.position = NEW_ITEM_POSITION
	ui.add_child(item)

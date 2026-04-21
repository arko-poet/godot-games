extends Node

const ITEM_SCENES: Array[PackedScene] = [
	preload("res://sauce/items/stone/stone.tscn"),
	preload("res://sauce/items/flower/flower.tscn"),
	preload("res://sauce/items/beef/beef.tscn"),
	preload("res://sauce/items/mace/mace.tscn"),
	preload("res://sauce/items/gloves/gloves.tscn")
]
const BAG_SCENES: Array[PackedScene] = [
	preload("res://sauce/bag/satchel/satchel.tscn")
]
const DRAG_CURSOR := preload(
	"res://assets/kenney_cursor-pack/PNG/Outline/Default/hand_closed.png"
)
const HOVER_CURSOR := preload(
	"res://assets/kenney_cursor-pack/PNG/Outline/Default/gauntlet_point.png"
)

@onready var ui: Control = $UILayer/UI
@onready var inventory: Inventory = $UILayer/UI/Inventory
@onready var combat_log: RichTextLabel = $UILayer/UI/CombatLog
@onready var item_box: Control = $UILayer/UI/ItemBox


func _ready() -> void:
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_DRAG)
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(HOVER_CURSOR, Input.CURSOR_POINTING_HAND)

	_on_combat_finished() # TODO remove this
	LogManager.combat_log = combat_log


func _input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton
	if mb != null:
		if mb.button_index == MOUSE_BUTTON_RIGHT:
			get_viewport().set_input_as_handled()
			if not mb.pressed and get_viewport().gui_is_dragging():
				var data: Dictionary = get_viewport().gui_get_drag_data()
				var item: Item = data["item"]
				item.rotate()
				data["offset"] = Vector2(-data["offset"].y, data["offset"].x)
				

func _on_player_died() -> void:
	get_tree().reload_current_scene()


func _on_combat_finished() -> void:
	#var item := ITEM_SCENES[randi() % ITEM_SCENES.size()].instantiate()
	var item: Item = ITEM_SCENES[4].instantiate()
	item.rotated.connect(_on_item_rotated)
	item.position = Vector2.ZERO
	item_box.add_child(item)
	
	var bag: Bag = BAG_SCENES[0].instantiate()
	#item.rotated.connect(_on_item_rotated)
	#item.position = Vector2.ZERO
	item_box.add_child(bag)


func _on_item_rotated() -> void:
	inventory.rotate_hovered_cells()


func _on_combat_started(_combat_number: int) -> void:
	combat_log.clear()

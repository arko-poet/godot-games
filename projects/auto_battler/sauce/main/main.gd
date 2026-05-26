extends Node

const ITEM_SCENES: Array[PackedScene] = [
	preload("res://sauce/inventory_components/bags/bag.tscn"),
	preload("res://sauce/inventory_components/items/flower/flower.tscn"),
	preload("res://sauce/inventory_components/items/beef/beef.tscn"),
	preload("res://sauce/inventory_components/items/mace/mace.tscn"),
	preload("res://sauce/inventory_components/items/gloves/gloves.tscn")
]
const BAG_SCENES: Array[PackedScene] = [
	preload("res://sauce/inventory_components/bags/satchel/satchel.tscn"),
	preload("res://sauce/inventory_components/bags/knapsack/knapsack.tscn")
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
#@onready var item_box: Control = $UILayer/UI/ItemBox
@onready var test_item: RigidBody2D = $World/TestItem
@onready var stone: Control = $UILayer/UI/Stone


func _ready() -> void:
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_DRAG)
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(HOVER_CURSOR, Input.CURSOR_POINTING_HAND)

	_on_combat_finished() # CAUTION remove this once debugging finished
	LogManager.combat_log = combat_log
	
	# test association between Physical items and InventoryComponents
	test_item.inventory_component = stone
	stone.physical_item = test_item


func _input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton
	if mb != null:
		if mb.button_index == MOUSE_BUTTON_RIGHT:
			if get_viewport().gui_is_dragging():
				get_viewport().set_input_as_handled()
			if not mb.pressed and get_viewport().gui_is_dragging():
				var data: Dictionary = get_viewport().gui_get_drag_data()
				data["cell_held"] = Vector2i(-data["cell_held"].y, data["cell_held"].x)
				data["preview"].rotation += PI / 2
				var ic: InventoryComponent = data.get("inventory_component", null)
				ic.rotate()
				data["offset"] = Vector2(-data["offset"].y, data["offset"].x)


func _on_player_died() -> void:
	get_tree().reload_current_scene()


func _on_combat_finished() -> void:
	#var item := ITEM_SCENES[randi() % ITEM_SCENES.size()].instantiate() WARNING dont remove this
	var item: Item = ITEM_SCENES[4].instantiate()
	item.rotated.connect(_on_item_rotated)
	add_child(item)
	
	var bag: Bag = BAG_SCENES[1].instantiate()
	bag.rotated.connect(_on_bag_rotated)
	add_child(bag)
	
	# test
	bag.reparent(inventory)
	bag.position = Vector2(50, 150)


func _on_item_rotated() -> void:
	inventory.rotate_hovered_cells()


func _on_bag_rotated() -> void:
	inventory.rotate_hovered_cells()


func _on_combat_started(_combat_number: int) -> void:
	combat_log.clear()

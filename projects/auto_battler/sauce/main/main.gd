extends Node

# note ITEM_SCENES and PHYSICAL_ITEM_SCENES must follow same order
const ITEM_SCENES: Array[PackedScene] = [
	preload("res://sauce/inventory_components/items/stone/stone.tscn"),
	preload("res://sauce/inventory_components/items/flower/flower.tscn"),
	preload("res://sauce/inventory_components/items/beef/beef.tscn"),
	preload("res://sauce/inventory_components/items/mace/mace.tscn"),
	preload("res://sauce/inventory_components/items/gloves/gloves.tscn")
]
const PHYSICAL_ITEM_SCENES: Array[PackedScene] = [
	preload("res://sauce/physical_components/physical_stone.tscn")
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
@onready var world: Node2D = $World


func _ready() -> void:
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_DRAG)
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(DRAG_CURSOR, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(HOVER_CURSOR, Input.CURSOR_POINTING_HAND)

	_on_combat_finished() # CAUTION remove this once debugging finished
	LogManager.combat_log = combat_log


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
	# WARNING dont remove this (production)
	#var item_index := randi() % ITEM_SCENES.size()
	#var item := ITEM_SCENES[item_index].instantiate() 
	#var physical_item := PHYSICAL_ITEM_SCENES[item_index]
	
	# TEST item
	var item: Item = ITEM_SCENES[0].instantiate()
	item.rotated.connect(_on_item_rotated)
	add_child(item)
	var physical_item: PhysicalComponent = PHYSICAL_ITEM_SCENES[0].instantiate()
	world.add_child(physical_item)
	item.physical_item = physical_item
	item.hide()
	physical_item.inventory_component = item
	physical_item.position = Vector2(50, 150)
	item.position = Vector2(50, 150)
	
	# TEST bag
	var bag: Bag = BAG_SCENES[1].instantiate()
	bag.rotated.connect(_on_bag_rotated)
	add_child(bag)
	bag.reparent(inventory)
	bag.position = Vector2(50, 150)


func _on_item_rotated() -> void:
	inventory.rotate_hovered_cells()


func _on_bag_rotated() -> void:
	inventory.rotate_hovered_cells()


func _on_combat_started(_combat_number: int) -> void:
	combat_log.clear()

class_name Main extends Node

const COMPONENT_SPAWN_POSITION := Vector2(50, 150)
# note ITEM_SCENES and PHYSICAL_ITEM_SCENES must follow same order
const ITEM_SCENES: Array[PackedScene] = [
	preload("res://sauce/inventory_components/items/stone/stone.tscn"),
	preload("res://sauce/inventory_components/items/flower/flower.tscn"),
	preload("res://sauce/inventory_components/items/beef/beef.tscn"),
	preload("res://sauce/inventory_components/items/mace/mace.tscn"),
	preload("res://sauce/inventory_components/items/gloves/gloves.tscn")
]
const PHYSICAL_ITEM_SCENES: Array[PackedScene] = [
	preload("res://sauce/rigid_components/items/rigid_stone.tscn"),
	preload("res://sauce/rigid_components/items/rigid_flower.tscn"),
	preload("res://sauce/rigid_components/items/rigid_beef.tscn"),
	preload("res://sauce/rigid_components/items/rigid_mace.tscn"),
	preload("res://sauce/rigid_components/items/rigid_gloves.tscn"),
]
const PHYSICAL_BAG_SCENES: Array[PackedScene] = [
	preload("res://sauce/rigid_components/bags/rigid_satchel.tscn"),
	preload("res://sauce/rigid_components/bags/rigid_knapsack.tscn")
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

	LogManager.combat_log = combat_log
	
	_test_add_all_items()
	#_add_starter_items()


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
	# reward with new item
	var scene_index: int
	var is_bag := randf() < 0.5
	if is_bag:
		scene_index = randi() % BAG_SCENES.size()
	else:
		scene_index = randi() % ITEM_SCENES.size()
	_add_new_component(scene_index, is_bag)


func _on_item_rotated() -> void:
	inventory.rotate_hovered_cells()


func _on_bag_rotated() -> void:
	inventory.rotate_hovered_cells()


func _on_combat_started(_combat_number: int) -> void:
	combat_log.clear()


func _test_add_all_items() -> void:
	for i in ITEM_SCENES.size():
		_add_new_component(i)


	for i in BAG_SCENES.size():
		_add_new_component(i, true)


func _add_starter_items() -> void:
	_add_new_component(3)
	_add_new_component(1, true)


## creates and adds item or bag to the game
func _add_new_component(scene_index: int, is_bag: bool = false) -> void:
	var inventory_component: InventoryComponent
	var rigid_component: RigidComponent
	if is_bag:
		inventory_component = BAG_SCENES[scene_index].instantiate()
		rigid_component = PHYSICAL_BAG_SCENES[scene_index].instantiate()
	else:
		inventory_component = ITEM_SCENES[scene_index].instantiate() 
		rigid_component = PHYSICAL_ITEM_SCENES[scene_index].instantiate()
		
	ui.add_child(inventory_component)
	world.add_child(rigid_component)
	
	inventory_component.rotated.connect(_on_item_rotated)
	inventory_component.hide()
	
	inventory_component.physical_item = rigid_component
	rigid_component.inventory_component = inventory_component
	
	rigid_component.position = COMPONENT_SPAWN_POSITION
	inventory_component.position = COMPONENT_SPAWN_POSITION

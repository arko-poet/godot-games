@abstract
class_name Item
extends Control

signal used(action: CombatAction)
signal rotated

@export var display_name: String

## which cells is item going to occupy at each rotation state
var footprints: Array[Array] = [] # Array[Array[Vector2i]] is not supported
var footprint_index := 0
## actual item position after rotation
var rotation_offsets: Array[Vector2i] = [] 
var preview_sprite: Control
var cell_held: Vector2i

@onready var sprite: ColorRect = $Sprite
@onready var effect_timer: Timer = $EffectTimer


func _ready() -> void:
	_set_footprints()
	_set_rotation_offsets()


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		show()


## for overriding, should return an effect item produces when added to inventory
func get_passive_effect() -> Dictionary:
	return {}


func get_footprint() -> Array[Vector2i]:
	# have to convert to Array[Vector2i] cause godot doesnt support nested generics
	var footprint: Array[Vector2i] = []
	for cell in footprints[footprint_index]:
		footprint.append(cell)
	return footprint


func get_rotation_offset() -> Vector2i:
	return rotation_offsets[footprint_index]


func rotate() -> void:
	rotation += PI / 2
	preview_sprite.rotation += PI / 2
	footprint_index = (footprint_index + 1) % footprints.size()
	cell_held = Vector2i(-cell_held.y, cell_held.x)
	rotated.emit()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		assert(event.pressed)
		
		_start_dragging()


func _get_actions() -> Array[CombatAction]:
	return []


func _on_effect_timer_timeout() -> void:
	for action in _get_actions():
		used.emit(action)


func _start_dragging() -> void:
	var mp := get_local_mouse_position()
	preview_sprite = sprite.duplicate()
	preview_sprite.position -= mp
	
	var preview := Control.new()
	preview.rotation = rotation
	preview.size = preview_sprite.size
	preview.add_child(preview_sprite)
	preview_sprite.pivot_offset = mp
	
	var drag_data := {
		"item": self,
		"offset": mp
	}
	_set_cell_held()
	
	force_drag.call_deferred(drag_data, preview)
	hide()


func _set_cell_held() -> void:
	var mp := get_local_mouse_position()
	cell_held = Vector2i(
		floori(mp.x / Globals.CELL_SIZE),
		floori(mp.y / Globals.CELL_SIZE)
	)
	for i in range(footprint_index):
		cell_held = Vector2i(-cell_held.y, cell_held.x)


@abstract
func _set_footprints() -> void
	
	
@abstract
func _set_rotation_offsets() -> void

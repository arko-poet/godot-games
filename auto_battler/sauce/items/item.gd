@abstract
class_name Item extends Control

signal used(action: CombatAction)
signal rotated

@export var display_name: String

## which cells is item going to occupy at each rotation state
var footprint: Array[Vector2i] = []
var preview_sprite: Control
var cell_held: Vector2i
var bonus_cells: Array[Vector2i] = []
var bonus: Dictionary
var base_cooldown: float
var cdr := 0.0

@onready var sprite: ColorRect = $Sprite
@onready var effect_timer: Timer = $EffectTimer


func _ready() -> void:
	base_cooldown = effect_timer.wait_time
	_set_footprint()
	_set_bonus_cells()


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		show()


## for overriding, should return an effect item produces when added to inventory
func get_passive_effect() -> Dictionary:
	return {}


func get_bonus() -> Dictionary:
	return {}


## return visual top left corner of the Item while respecting rotation
func get_top_left_corner() -> Vector2:
	var local_transform = Transform2D(rotation, Vector2.ZERO)
	var local_rect = Rect2(Vector2.ZERO, get_rect().size)
	return (local_transform * local_rect).position


func rotate() -> void:
	rotation += PI / 2
	preview_sprite.rotation += PI / 2
	cell_held = Vector2i(-cell_held.y, cell_held.x)
	for i in footprint.size():
		footprint[i] = Vector2i(-footprint[i].y, footprint[i].x)
	print(footprint)
	rotated.emit()


func apply_bonus(item: Item) -> void:
	if item.get_bonus().has("cooldown"):
		cdr += item.get_bonus()["cooldown"]
		effect_timer.wait_time = base_cooldown / (1.0 + cdr)
		


func remove_bonus(item: Item) -> void:
	if item.get_bonus().has("cooldown"):
		cdr -= item.get_bonus()["cooldown"]
		effect_timer.wait_time = base_cooldown / (1.0 + cdr)


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
	var mp := get_local_mouse_position() / Globals.CELL_SIZE
	cell_held = Vector2i(mp * Transform2D(-rotation, Vector2.ZERO))


@abstract
func _set_footprint() -> void


func _set_bonus_cells() -> void: # TODO this should be called bonus footprint
	pass
	

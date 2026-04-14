class_name Item
extends Control

signal used(effect: Dictionary) ## items create effects which are executed during combat

## which cells is item going to occupy at each rotation state
var footprints: Array[Array] = [] # Array[Array[Vector2i]] is not supported
var footprint_index := 0
var preview_sprite: Control

@onready var sprite: ColorRect = $Sprite
@onready var effect_timer: Timer = $EffectTimer


func _ready() -> void:
	_set_footprints()


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		show()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			get_viewport().set_input_as_handled()
			if not event.pressed and get_viewport().gui_is_dragging():
				rotate()
				#var drag_data: Dictionary = get_viewport().gui_get_drag_data()
				#var item: Item = drag_data["item"]

## for overriding, should return an effect item produces when added to inventory
func get_passive_effect() -> Dictionary:
	return {}


func get_footprint() -> Array[Vector2i]:
	# have to convert to Array[Vector2i] cause godot doesnt support nested generics
	var footprint: Array[Vector2i] = []
	for cell in footprints[footprint_index]:
		footprint.append(cell)
	return footprint


func rotate() -> void:
	print("rotate")
	#print(pivot_offset)
	#print(position)
	print(preview_sprite.pivot_offset)
	rotation += PI / 2
	preview_sprite.rotation += PI / 2
	footprint_index = (footprint_index + 1) % footprints.size()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		assert(event.pressed)
		
		_start_dragging()


## for overriding, should return an effect item produces on cooldown
func _get_active_effect() -> Dictionary:
	return {}


func _on_effect_timer_timeout() -> void:
	used.emit(_get_active_effect())


func _start_dragging() -> void:
	preview_sprite = sprite.duplicate()
	preview_sprite.position -= get_local_mouse_position()
	
	var preview := Control.new()
	preview.size = preview_sprite.size
	preview.add_child(preview_sprite)
	preview_sprite.pivot_offset = get_local_mouse_position()
	
	var drag_data := {}
	drag_data["item"] = self
	drag_data["cell_held"] = _get_cell_held()
	
	force_drag.call_deferred(drag_data, preview)
	hide()


func _get_cell_held() -> Vector2i:
	var mp := get_local_mouse_position()
	var cell := Vector2i(
		floori(mp.x / Globals.CELL_SIZE),
		floori(mp.y / Globals.CELL_SIZE)
	)
	return cell


func _set_footprints() -> void:
	push_error("Each item must override _set_footprint")

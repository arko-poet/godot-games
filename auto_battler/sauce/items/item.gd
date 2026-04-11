class_name Item
extends Control

signal used(effect: Dictionary) ## items create effects which are executed during combat

var footprint: Array[Vector2i] = []

@onready var sprite: ColorRect = $Sprite
@onready var effect_timer: Timer = $EffectTimer


func _ready() -> void:
	_set_footprint()


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		show()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		assert(event.pressed)
		
		_start_dragging()


## for overriding, should return an effect item produces when added to inventory
func get_passive_effect() -> Dictionary:
	return {}


## for overriding, should return an effect item produces on cooldown
func _get_active_effect() -> Dictionary:
	return {}


func _on_effect_timer_timeout() -> void:
	used.emit(_get_active_effect())


func _start_dragging() -> void:
	var sprite_preview := sprite.duplicate()
	var offset = global_position - get_global_mouse_position()
	sprite_preview.position = offset
	
	var preview := Control.new()
	preview.size = size
	preview.add_child(sprite_preview)
	preview.mouse_default_cursor_shape = Control.CURSOR_DRAG
	
	var drag_data := {}
	drag_data["offset"] = offset
	drag_data["item"] = self
	
	force_drag.call_deferred(drag_data, preview)
	hide()


func _set_footprint() -> void:
	footprint.append(Vector2i.ZERO)

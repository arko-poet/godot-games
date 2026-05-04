class_name Item extends InventoryComponent

signal used(action: CombatAction)

@export var display_name: String
@export var bonus_cells: Array[Vector2i] = []
## a bit of memory waste, but I wanted footprint to be setup in Inspector
## could be removed and hard coded in _ready() instead
@export var _footprint: Array[Vector2i] = [Vector2i.ZERO]

## which cells is item going to occupy at each rotation state
var bonus: Dictionary
var base_cooldown: float
var cdr := 0.0

@onready var sprite: ColorRect = $Sprite
@onready var _effect_timer: Timer = $EffectTimer


func _ready() -> void:
	for f in _footprint:
		footprint.append(f)

	base_cooldown = _effect_timer.wait_time


func start() -> void:
	#sprite.material.set_shader_parameter("progress", 0.0)
	_effect_timer.start()
	_animate_progress()
	
	
func stop() -> void:
	_effect_timer.stop()


## for overriding, should return an effect item produces when added to inventory
func get_passive_effect() -> Dictionary:
	return {}


func get_bonus() -> Dictionary:
	return {}


func rotate() -> void:
	for i in bonus_cells.size():
		bonus_cells[i] = Vector2i(-bonus_cells[i].y, bonus_cells[i].x)
	super.rotate()


func apply_bonus(item: Item) -> void:
	if item.get_bonus().has("cooldown"):
		cdr += item.get_bonus()["cooldown"]
		_effect_timer.wait_time = base_cooldown / (1.0 + cdr)


func remove_bonus(item: Item) -> void:
	if item.get_bonus().has("cooldown"):
		cdr -= item.get_bonus()["cooldown"]
		_effect_timer.wait_time = base_cooldown / (1.0 + cdr)


func _unrotate() -> void:
	var rotation_coutner_copy = rotation_counter
	while rotation_coutner_copy > 0:
		rotation_coutner_copy -= 1
		
		for i in bonus_cells.size():
			bonus_cells[i] = Vector2i(bonus_cells[i].y, -bonus_cells[i].x)
			
	super._unrotate()


func _get_actions() -> Array[CombatAction]:
	return []


func _on_effect_timer_timeout() -> void:
	for action in _get_actions():
		used.emit(action)


func _animate_progress() -> void:
	(sprite.material as ShaderMaterial).set_shader_parameter("item_rotation", rotation)
	(sprite.material as ShaderMaterial).set_shader_parameter("progress", 0.0)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite.material, "shader_parameter/progress", 1.0, _effect_timer.wait_time)
	tween.finished.connect(_animation_helper)


func _animation_helper() -> void:
	if not _effect_timer.is_stopped():
		_animate_progress()
	else:
		(sprite.material as ShaderMaterial).set_shader_parameter("progress", 1.0)


func _create_drag_preview(preview_position: Vector2) -> Control:
	var preview_sprite: Control = sprite.duplicate()
	preview_sprite.position -= preview_position
	
	var preview := Control.new()
	preview.rotation = rotation
	preview.add_child(preview_sprite)
	preview_sprite.pivot_offset = preview_position
	
	return preview


func _create_drag_data(drag_preview: Control, preview_position: Vector2) -> Dictionary:
	return {
		"inventory_component": self,
		"offset": preview_position * Transform2D(-rotation, Vector2.ZERO),
		"cell_held": _get_cell_held(preview_position),
		"preview": drag_preview
	}

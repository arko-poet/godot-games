class_name Tower
extends Node2D

signal player_fell_off

const BASE_SCROLL_SPEED = 100.0
const FLOOR_SCENE := preload("res://floor.tscn")
const FLOOR_COUNT := 10
const FLOOR_SPACING := 100
const FLOOR_HEIGHT := 32
const MIN_FLOOR_WIDTH := 64
const MAX_FLOOR_WIDTH := 256
const MAX_CAMERA_BOOST := 4.0
const WALL_WIDTH := 102.4 # TODO set actual wall width to this
const SCROLL_MULTI_INCREMENT := 0.2
const WIDE_FLOOR_FREQUENCY := 50

var scroll_multiplier := 1.0
var has_started_scrolling := false
var floors : Array[Floor] = []
var viewport_size : Vector2
var level := 0
var has_fallen := false

@onready var camera : Camera2D = $Camera
@onready var player : Node2D = $Player
@onready var scroll_multi_timer : Timer = $ScrollMultiTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	
	# initialise pool of floors
	for i in range(FLOOR_COUNT):
		var f : Floor = FLOOR_SCENE.instantiate()
		f.level = i
		add_child(f)
		_set_floor_properties(f)
		floors.append(f)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move up the tower
	var dy := delta * BASE_SCROLL_SPEED * scroll_multiplier
	var camera_center : Vector2 = camera.global_position + viewport_size * 0.5
	var offset_ratio = (player.position.y - camera_center.y) / (viewport_size.y * 0.5)
	if offset_ratio <= 0.5:
		has_started_scrolling = true
		if scroll_multi_timer.is_stopped():
			scroll_multi_timer.start()
	if offset_ratio < 0.0: 
		dy *= 1.0 + MAX_CAMERA_BOOST * abs(offset_ratio)
	if has_started_scrolling:
		camera.global_position.y -= dy

	# floor pooling - move floors up if they leave screen
	if camera.global_position.y + viewport_size.y + FLOOR_HEIGHT * 0.5 < floors[0].position.y:
		var first_floor : Floor = floors.pop_front()
		level = first_floor.level
		first_floor.level += FLOOR_COUNT
		_set_floor_properties(first_floor)
		floors.push_back(first_floor)

	if player.position.y - player.SIZE > camera.global_position.y + viewport_size.y:
		if not has_fallen:
			has_fallen = true
			player_fell_off.emit()


## sets position and size of floor
func _set_floor_properties(f: Floor):
	var floor_size := Vector2i(0, FLOOR_HEIGHT)
	var floor_position := Vector2.ZERO
	if f.level % WIDE_FLOOR_FREQUENCY == 0:
		floor_size.x = int(viewport_size.x - WALL_WIDTH)
		floor_position.x = viewport_size.x / 2
	else:
		floor_size.x = randi_range(MIN_FLOOR_WIDTH, MAX_FLOOR_WIDTH)
		var x_offset = WALL_WIDTH + floor_size.x * 0.5
		floor_position.x = randf_range(x_offset, viewport_size.x - x_offset)
	floor_position.y = viewport_size.y - FLOOR_SPACING * f.level - FLOOR_HEIGHT * 0.5
	
	f.set_size(floor_size)
	f.position = floor_position


func _on_scroll_multi_timer_timeout() -> void:
	$ScrollMultiSound.play()
	scroll_multiplier += SCROLL_MULTI_INCREMENT


func get_time_left() -> float:
	return scroll_multi_timer.time_left

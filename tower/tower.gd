extends Node2D

signal player_fell_off

const SCROLL_SPEED = 100
const FLOOR_SCENE := preload("res://floor.tscn")
const FLOOR_COUNT := 10
const FLOOR_SPACING := 100
const FLOOR_HEIGHT := 32
const MIN_FLOOR_WIDTH := 64
const MAX_FLOOR_WIDTH := 256
const MAX_CAMERA_BOOST := 4.0
const WALL_WIDTH := 102.4 # TODO set actual wall width to this

var floors : Array[Floor] = []
var viewport_size : Vector2
@onready var camera : Camera2D = $Camera
@onready var player : Node2D = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	
	# initialise pool of floors
	for i in range(FLOOR_COUNT):
		var f : Floor = FLOOR_SCENE.instantiate()
		f.position.y += viewport_size.y - FLOOR_HEIGHT * 0.5
		add_child(f)
		_set_floor_properties(f, i)
		floors.append(f)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move up the tower
	var dy = delta * SCROLL_SPEED
	var camera_center : Vector2 = camera.global_position + viewport_size * 0.5
	var offset_ratio = (player.position.y - camera_center.y) / (viewport_size.y * 0.5)
	if offset_ratio < 0.0: 
		dy *= 1.0 + MAX_CAMERA_BOOST * abs(offset_ratio)
	camera.global_position.y -= dy

	# floor pooling - move floors up if they leave screen
	if camera.global_position.y + viewport_size.y + FLOOR_HEIGHT * 0.5 < floors[0].position.y:
		var first_floor : Floor = floors.pop_front()
		_set_floor_properties(first_floor)
		floors.push_back(first_floor)
	
	if player.position.y - player.SIZE > camera.global_position.y + viewport_size.y:
		player_fell_off.emit()


## i is an index representing position of Floor in floors Array
## i is only meant to be used when initialising floors Array
## i defaults to FLOOR_COUNT so that it can be repositioned to the top of Array
func _set_floor_properties(f: Floor, i: int = FLOOR_COUNT):
	var width := randi_range(MIN_FLOOR_WIDTH, MAX_FLOOR_WIDTH)
	if i == 0:
		width = 800
	f.set_size(Vector2(width, FLOOR_HEIGHT))
	f.position.y -= FLOOR_SPACING * i
	var x_offset = WALL_WIDTH + width * 0.5
	f.position.x = randf_range(x_offset, viewport_size.x - x_offset)

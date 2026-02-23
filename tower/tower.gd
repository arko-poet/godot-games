extends Node2D

const SCROLL_SPEED = 100
const FLOOR_SCENE := preload("res://floor.tscn")
const FLOOR_COUNT := 20
const FLOOR_SPACING := 100
const FLOOR_HEIGHT := 64

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
		f.position.y -= FLOOR_SPACING * i - viewport_size.y
		f.position.x = viewport_size.x * 0.5
		f.set_size(Vector2(128, FLOOR_HEIGHT))
		floors.append(f)
		add_child(f)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move up the tower
	var dy = delta * SCROLL_SPEED
	var camera_center : Vector2 = camera.global_position + viewport_size * 0.5
	var offset_ratio = (player.position.y - camera_center.y) / (viewport_size.y * 0.5)
	if offset_ratio < 0.0: 
		dy *= 1.0 + 4.0 * abs(offset_ratio)
	camera.global_position.y -= dy

	# pooling of floors
	if camera.global_position.y + viewport_size.y + FLOOR_HEIGHT * 0.5 < floors[0].position.y:
		var first_floor : Floor = floors.pop_front()
		first_floor.position.y -= FLOOR_COUNT * FLOOR_SPACING
		floors.push_back(first_floor)

extends Node2D

const SCROLL_SPEED = 100
const FLOOR_SCENE := preload("res://floor.tscn")
const FLOOR_COUNT := 20
const FLOOR_SPACING := 100
const FLOOR_HEIGHT := 64

var floors : Array[Floor] = []
var viewport_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialise pool of floors
	for i in range(FLOOR_COUNT):
		var f : Floor = FLOOR_SCENE.instantiate()
		viewport_size = get_viewport().get_visible_rect().size
		f.position.y -= FLOOR_SPACING * i - viewport_size.y
		f.position.x = viewport_size.x * 0.5
		f.set_size(Vector2(128, FLOOR_HEIGHT))
		floors.append(f)
		add_child(f)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move up the tower
	var dy = delta * SCROLL_SPEED
	$Camera.global_position.y -= dy
	$LeftWall.position.y -= dy
	$RightWall.position.y -= dy

	# pooling of floors
	if $Camera.global_position.y + viewport_size.y + FLOOR_HEIGHT * 0.5 < floors[0].position.y:
		var first_floor : Floor = floors.pop_front()
		first_floor.position.y -= len(floors) * FLOOR_SPACING
		floors.push_back(first_floor)

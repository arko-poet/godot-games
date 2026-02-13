class_name Tetromino
extends Node2D

const BLOCK_SCENE := preload("res://block.tscn")
const STATES := [
	[  # I
		[[1, 0], [1, 1], [1, 2], [1, 3]],
		[[0, 2], [1, 2], [2, 2], [3, 2]],
		[[2, 0], [2, 1], [2, 2], [2, 3]],
		[[0, 1], [1, 1], [2, 1], [3, 1]]
	],
	[ # J
		[[0, 0], [1, 0], [1, 1], [1, 2]],
		[[0, 1], [0, 2], [1, 1], [2, 1]],
		[[1, 0], [1, 1], [1, 2], [2, 2]],
		[[2, 0], [0, 1], [1, 1], [2, 1]]
	],
	[ # J
		[[0, 2], [1, 0], [1, 1], [1, 2]],
		[[0, 1], [1, 1], [2, 1], [2, 2]],
		[[1, 0], [1, 1], [1, 2], [2, 0]],
		[[0, 0], [0, 1], [1, 1], [2, 1]]
	],
	[ # O
		[[0, 1], [0, 2], [1, 1], [1, 2]],
		[[0, 1], [0, 2], [1, 1], [1, 2]],
		[[0, 1], [0, 2], [1, 1], [1, 2]],
		[[0, 1], [0, 2], [1, 1], [1, 2]]
	],
	[ # S
		[[0, 1], [0, 2], [1, 0], [1, 1]],
		[[0, 1], [1, 1], [1, 2], [2, 2]],
		[[1, 1], [1, 2], [2, 0], [2, 1]],
		[[0, 0], [1, 0], [1, 1], [2, 1]]
	],
	[ # Z
		[[0, 0], [0, 1], [1, 1], [1, 2]],
		[[0, 2], [1, 1], [1, 2], [2, 1]],
		[[1, 0], [1, 1], [2, 1], [2, 2]],
		[[0, 1], [1, 0], [1, 1], [2, 0]]
	],
	[ # T
		[[0, 1], [1, 0], [1, 1], [1, 2]],
		[[0, 1], [1, 1], [1, 2], [2, 1]],
		[[1, 0], [1, 1], [1, 2], [2, 1]],
		[[0, 1], [1, 0], [1, 1], [2, 1]]
	]
]

var grid_position := Vector2i(3, 0)
var shape : int
var state_i := 0
var texture_path : String
var blocks: Array[Block]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# choose tetromino shape
	shape = randi() % len(STATES)
	texture_path = "res://sprites/Tetromino_block2_%s.png" % shape
	for i in range(len(STATES[shape])):
		var block : Block = BLOCK_SCENE.instantiate()
		block.texture = load(texture_path) ## TODO check if this is best way
		blocks.append(block)
		add_child(block)


func rotate_mat() -> void:
	state_i = (state_i + 1) % len(blocks)

func get_block_vector(block_index: int) -> Vector2i:
	var pos = STATES[shape][state_i][block_index]
	return Vector2i(pos[1], pos[0]) + grid_position

func get_next_rotation_state() -> Array:
		return STATES[shape][(state_i + 1) % len(blocks)]

extends Node

const TETROMINO_SCENE := preload("res://tetromino.tscn")
const FIREBALL_SCENE := preload("res://fireball.tscn")
const HORIZONTAL_CELLS := 10
const VERTICAL_CELLS := 20
const NORMAL_DROP_TIME := 0.2
const FAST_DROP_TIME := 0.05
const CELL_SIZE := 30
const ROW_SCORE := [0, 100, 300, 500, 800]

var grid : Array
var tetromino : Tetromino
var score := 0
var level := 0

signal game_over

func _ready() -> void:
	# initialise grid
	for i in range(VERTICAL_CELLS):
		var row := Array()
		row.resize(HORIZONTAL_CELLS)
		grid.append(row)
	
	_countdown()


func _process(_delta: float) -> void:
	if tetromino:
		# adjust tetromino drop time based on input
		if Input.is_action_pressed("move_down"):
			_update_drop_timer(FAST_DROP_TIME)
		else:
			_update_drop_timer(NORMAL_DROP_TIME)
		
		if Input.is_action_just_pressed("rotate"):
			if _can_rotate():
				tetromino.rotate_mat()
		
		# draw blocks in the grid
		for row in range(len(grid)):
			for col in range(len(grid[row])):
				if grid[row][col]:
					grid[row][col].position.x = col * CELL_SIZE
					grid[row][col].position.y = row * CELL_SIZE

		# draw tetromino
		for i in range(len(tetromino.blocks)):
			var block : Block = tetromino.blocks[i]
			block.position = tetromino.get_block_vector(i) * CELL_SIZE


## change tetromino drop time if needed
func _update_drop_timer(time: float) -> void:
	if $DropTimer.wait_time != time:
		$DropTimer.wait_time = time
		$DropTimer.start()


func _new_tetromino() -> void:
	level += 1
	tetromino = TETROMINO_SCENE.instantiate()
	add_child(tetromino)
	if not _can_tetromino_move(Vector2i(0, 0)):
		game_over.emit()


## check if there is space for tetromino to move
func _can_tetromino_move(v : Vector2i) -> bool:
	for i in range(len(tetromino.blocks)):
		var pos : Vector2i = tetromino.get_block_vector(i)
		if not (
				pos.x + v.x >= 0 and 
				pos.x + v.x < HORIZONTAL_CELLS and 
				pos.y + v.y < VERTICAL_CELLS and 
				grid[pos.y + v.y][pos.x + v.x] == null
		):
			return false
	return true


## tetrominos drop down when timer ticks
func _drop_timer_timeout() -> void:
	var v := Vector2i(0, 1)
	if _can_tetromino_move(v):
		tetromino.grid_position += v
		if $DropTimer.wait_time == FAST_DROP_TIME:
			score += 1
	else:
		for i in range(len(tetromino.blocks)):
			var pos : Vector2i = tetromino.get_block_vector(i)
			grid[pos.y ][pos.x] = tetromino.blocks[i]
		_clean_rows()
		_new_tetromino()


## horizontal movement of teromino is based on timer ticks
func _on_strafe_timer_timeout() -> void:
	var v := Vector2i.ZERO
	if Input.is_action_pressed("move_left"):
		v.x -= 1
	if Input.is_action_pressed("move_right"):
		v.x += 1
	if _can_tetromino_move(v):
		tetromino.grid_position += v


## destroy full rows and recompute grid
func _clean_rows() -> void:
	var delete_rows : Array[int] = []
	for row in range(len(grid)):
		if not null in grid[row]:
			delete_rows.append(row)

	# animate row cleanup
	for row in delete_rows:
		for col in range(len(grid[row])):
			var block = grid[row][col]
			var t := create_tween()
			t.tween_interval(col * 0.05)
			t.tween_property(block, "scale", Vector2(0, 0), 0.05)
			t.finished.connect(block.queue_free)
			if col == len(grid[row]) - 1:
				t.finished.connect(_delete_row.bind(row))
		_create_clean_effect(row)
	
	score += level * ROW_SCORE[len(delete_rows)]

## fireball fx
func _create_clean_effect(row: int) -> void:
	var fireball = FIREBALL_SCENE.instantiate()
	fireball.position.y = row * CELL_SIZE + 17
	fireball.position.x = -60
	# utilising subviewport to clip fireball to the board
	$SubViewportContainer/SubViewport.add_child(fireball)
	var t := create_tween()
	t.tween_property(fireball , "position:x", CELL_SIZE * 12, 0.5)
	t.finished.connect(fireball .queue_free)


## check if tetromino has space to rotate
func _can_rotate() -> bool:
	var state : Array = tetromino.get_next_rotation_state()
	for pos in state:
		if (
				pos[0] + tetromino.grid_position.y < 0 or
				pos[0] + tetromino.grid_position.y > VERTICAL_CELLS - 1 or 
				pos[1] + tetromino.grid_position.x < 0 or 
				pos[1] + tetromino.grid_position.x > HORIZONTAL_CELLS - 1 or
				grid[pos[0] + tetromino.grid_position.y][pos[1] + tetromino.grid_position.x] != null
		):
			return false
	return true


## replace full row with a new one
func _delete_row(i : int):
	var new_row := Array()
	new_row.resize(HORIZONTAL_CELLS)
	grid.remove_at(i)
	grid.insert(0, new_row)


func _countdown(count : int = 3):
	$Background/CountdownLabel.text = str(count)
	$Background/CountdownLabel.scale = Vector2(0.1, 0.1)
	var t := create_tween()
	t.tween_property($Background/CountdownLabel, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if count > 0:
		t.finished.connect(_countdown.bind(count - 1))
	else:
		t.finished.connect(_new_tetromino)
		t.finished.connect($Background/CountdownLabel.hide)
		t.finished.connect($StrafeTimer.start)
		t.finished.connect($DropTimer.start)	

class_name World
extends Node2D

signal game_over
signal kill_count_changed
signal monster_hit(damage: int, coordinates: Vector2)

const MonsterScene := preload("res://sauce/monsters/monster.tscn")
const CHUNK_COUNT := 3
const SPAWN_TOLERANCE := 128.0
const MAX_SPAWN_ATTEMPTS := 256

var chunk_size: float
var kill_count := 0

@onready var left_chunk: WorldChunk = $Chunk
@onready var center_chunk: WorldChunk = $Chunk2
@onready var right_chunk: WorldChunk = $Chunk3
@onready var player: CharacterBody2D = $Player
@onready var monster_spawn_points: PathFollow2D = $Player/Path/MonsterSpawnPoints
@onready var monster_spawner: Timer = $MonsterSpawner


func _ready() -> void:
	chunk_size = abs(left_chunk.position.x - center_chunk.position.x)


func _process(_delta: float) -> void:
	# move chunks based on player position
	var temp_chunk = center_chunk
	var center_distance = player.position.x - center_chunk.position.x
	if center_distance < -0.5 * chunk_size:
		right_chunk.position.x -= chunk_size * CHUNK_COUNT
		center_chunk = left_chunk
		left_chunk = right_chunk
		right_chunk = temp_chunk
	elif center_distance > 0.5 * chunk_size:
		left_chunk.position.x += chunk_size * CHUNK_COUNT
		center_chunk = right_chunk
		right_chunk = left_chunk
		left_chunk = temp_chunk


func get_monster_spawn_point() -> Vector2:
	monster_spawn_points.progress_ratio = randf()
	var point := monster_spawn_points.global_position
	var nav_map := get_world_2d().navigation_map
	var closest := NavigationServer2D.map_get_closest_point(nav_map, point)
	var attempts := 0
	while closest.distance_to(point) > SPAWN_TOLERANCE:
		if attempts >= MAX_SPAWN_ATTEMPTS:
			return Vector2.INF
		attempts += 1
		
		monster_spawn_points.progress_ratio = randf()
		point = monster_spawn_points.global_position
		closest = NavigationServer2D.map_get_closest_point(nav_map, point)
	return closest


func _on_monster_spawner_timeout() -> void:
	var monster : Monster = MonsterScene.instantiate()
	var _spawn_point = get_monster_spawn_point()
	if _spawn_point == Vector2.INF:
		return
	monster.global_position = _spawn_point
	monster.set_target(player)
	monster.connect("monster_died", _on_monster_killed)
	add_child(monster)
	monster.hit_recieved.connect(_on_monster_hit_recived)


func _on_player_died() -> void:
	game_over.emit()


func _on_monster_killed() -> void:
	kill_count += 1
	kill_count_changed.emit()


func _on_spawn_acceleration_timeout() -> void:
	monster_spawner.wait_time *= 0.9


func _on_monster_hit_recived(damage: int, coordinates: Vector2) -> void:
	monster_hit.emit(damage, coordinates)

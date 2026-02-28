extends Node2D


const MonsterScene := preload("res://sauce/monster.tscn")
const CHUNK_COUNT := 3

var chunk_size : float

@onready var left_chunk : WorldChunk = $Chunk
@onready var center_chunk : WorldChunk = $Chunk2
@onready var right_chunk : WorldChunk = $Chunk3
@onready var player : CharacterBody2D = $Player
@onready var monster_spawn_points : PathFollow2D = $Player/Path/MonsterSpawnPoints


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
	return monster_spawn_points.global_position


func _on_monster_spawner_timeout() -> void:
	var monster := MonsterScene.instantiate()
	monster.set_target(player)
	add_child(monster)
	monster.global_position = get_monster_spawn_point()

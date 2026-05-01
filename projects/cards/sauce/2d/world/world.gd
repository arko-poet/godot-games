class_name World
extends Node2D

signal enemies_defeated

const TurdScene := preload("res://sauce/2d/monster/turd.tscn")
const TentacleScene := preload("res://sauce/2d/monster/tentacle.tscn")

const MONSTER_COORDINATES := Vector2(1280, 580)

@onready var monster: Monster = $Tentacle
@onready var character: Node2D = $Character


func spawn_monster(encounter_number: int) -> Monster:
	if encounter_number % 2 == 0:
		monster = TurdScene.instantiate()
	else:
		monster = TentacleScene.instantiate()
	monster.combat_num = encounter_number
	monster.position = MONSTER_COORDINATES
	monster.monster_died.connect(_on_monster_died)
	add_child(monster)
	return monster
	

func _on_monster_died() -> void:
	enemies_defeated.emit()

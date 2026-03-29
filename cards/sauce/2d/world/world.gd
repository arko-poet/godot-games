class_name World
extends Node2D

signal enemies_defeated
signal player_attacked(damage: int)

const TurdScene := preload("res://sauce/2d/monster/turd.tscn")

const MONSTER_COORDIANTES := Vector2(1280, 580)

@onready var monster: Monster = $Tentacle
@onready var character: Node2D = $Character


func new_monster() -> Monster:
	monster = TurdScene.instantiate()
	monster.position = MONSTER_COORDIANTES
	monster.monster_died.connect(_on_monster_died)
	monster.player_attacked.connect(_on_player_attacked)
	add_child(monster)
	return monster
	

func _on_monster_died() -> void:
	enemies_defeated.emit()


func _on_player_attacked(damage: int) -> void:
	emit_signal("player_attacked", damage)

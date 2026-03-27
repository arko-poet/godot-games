class_name World
extends Node2D

signal enemies_defeated

const TurdScene := preload("res://sauce/2d/monster/turd.tscn")

const MONSTER_COORDIANTES := Vector2(1280, 580)

@onready var monster: Monster = $Turd


func attack_monster(damage: int) -> void:
	monster.hp -= damage


func new_monster() -> Monster:
	monster = TurdScene.instantiate()
	monster.position = MONSTER_COORDIANTES
	monster.monster_died.connect(_on_monster_died)
	add_child(monster)
	return monster
	

func _on_monster_died() -> void:
	enemies_defeated.emit()
	monster.queue_free()

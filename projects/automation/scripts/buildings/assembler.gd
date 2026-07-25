extends Node2D

@onready var building_component: BuildingComponent = $BuildingComponent
@onready var sprite: Sprite2D = %Sprite
@onready var storage: StorageComponent = %Storage
@onready var production_timer: Timer = %ProductionTimer


func _ready():
	production_timer.start()

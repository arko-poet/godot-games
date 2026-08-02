extends Node2D

@onready var building_component: BuildingComponent = $BuildingComponent
@onready var storage: StorageComponent = %Storage
@onready var production_timer: Timer = %ProductionTimer


func _ready():
	production_timer.start()


func _on_production_timer_timeout() -> void:
	if not storage.has_stored_resource(Resources.Type.COAL):
		return
	if storage.has_stored_resource(Resources.Type.COPPER):
		_smelt_copper()
	elif storage.has_stored_resource(Resources.Type.SILVER):
		_smelt_silver()


func _smelt_copper() -> void:
	if not storage.withdraw_stored_resource(Resources.Type.COAL, true):
		push_error("No Coal in storage")
	if not storage.withdraw_stored_resource(Resources.Type.COPPER, true):
		push_error("No copper in storage")

	storage.store_resources(Resources.Type.COPPER_BAR, 1)


func _smelt_silver() -> void:
	if not storage.withdraw_stored_resource(Resources.Type.COAL, true):
		push_error("No Coal in storage")
	if not storage.withdraw_stored_resource(Resources.Type.SILVER, true):
		push_error("No silver in storage")

	storage.store_resources(Resources.Type.SILVER_BAR, 1)

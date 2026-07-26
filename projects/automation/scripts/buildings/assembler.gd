extends Node2D

@onready var building_component: BuildingComponent = $BuildingComponent
@onready var sprite: Sprite2D = %Sprite
@onready var storage: StorageComponent = %Storage
@onready var production_timer: Timer = %ProductionTimer


func _ready():
	production_timer.start()


func _on_production_timer_timeout() -> void:
	if (
		storage.has_stored_resource(Resources.Type.COPPER_WIRE)
		and storage.has_stored_resource(Resources.Type.SILVER_PLATE)
	):
		_make_automatron()
	if storage.has_stored_resource(Resources.Type.COPPER_BAR):
		_make_copper_wire()
	elif storage.has_stored_resource(Resources.Type.SILVER_BAR):
		_make_silver_plate()


func _make_copper_wire() -> void:
	if not storage.withdraw_stored_resource(Resources.Type.COPPER_BAR):
		push_error("No silver in storage")
	else:
		storage.store_resources(Resources.Type.COPPER_WIRE, 1)


func _make_silver_plate() -> void:
	if not storage.withdraw_stored_resource(Resources.Type.SILVER_BAR):
		push_error("No silver in storage")
	else:
		storage.store_resources(Resources.Type.SILVER_PLATE, 1)


func _make_automatron() -> void:
	if not storage.withdraw_stored_resource(Resources.Type.COPPER_WIRE):
		push_error("No copper wire in storage")
		return
	if not storage.withdraw_stored_resource(Resources.Type.SILVER_PLATE):
		push_error("No silver plate in storage")
		return
	storage.store_resources(Resources.Type.AUTOMATRON, 1)

extends Building

## order affects production priority
const _RECIPES := {
	Resources.Type.AUTOMATRON: [Resources.Type.SILVER_PLATE, Resources.Type.COPPER_WIRE],
	Resources.Type.SILVER_PLATE: [Resources.Type.SILVER_BAR],
	Resources.Type.COPPER_WIRE: [Resources.Type.COPPER_BAR],
}

@onready var sprite: Sprite2D = %Sprite
@onready var storage: StorageComponent = %Storage


func _on_production_timer_timeout() -> void:
	for product in _RECIPES.keys():
		if _make(product):
			break


func _make(product: Resources.Type) -> bool:
	var withdrawn_resources: Array[Resources.Type]
	for required_resource in _RECIPES.get(product, []):
		if not storage.withdraw_stored_resource(required_resource, true):
			for withdrawn_resource in withdrawn_resources:
				storage.store_resources(withdrawn_resource, 1)
			return false

		withdrawn_resources.append(required_resource)

	storage.store_resources(product, 1)

	if product == Resources.Type.AUTOMATRON:
		SignalController.automatron_created.emit()

	return true

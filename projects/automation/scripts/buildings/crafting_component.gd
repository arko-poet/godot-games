class_name CraftingComponent
extends Node

## order affects production priority
@export var recipes: Array[Recipe]


func make(recipe: Recipe, storage: StorageComponent) -> bool:
	var withdrawn_resources: Array[Resources.Type]
	for required_resource in recipe.ingredients:
		if not storage.withdraw_stored_resource(required_resource, true):
			for withdrawn_resource in withdrawn_resources:
				storage.store_resources(withdrawn_resource, 1)
			return false

		withdrawn_resources.append(required_resource)

	storage.store_resources(recipe.product, 1)

	if recipe.product == Resources.Type.AUTOMATRON:
		SignalController.automatron_created.emit()

	return true

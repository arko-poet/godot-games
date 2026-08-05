extends Building

@onready var storage: StorageComponent = %Storage
@onready var crafting_component: CraftingComponent = %CraftingComponent


func _on_production_timer_timeout() -> void:
	for recipe in crafting_component.recipes:
		if crafting_component.make(recipe, storage):
			break

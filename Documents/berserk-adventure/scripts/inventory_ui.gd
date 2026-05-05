extends Control

var slot_scene: PackedScene = preload("res://scenes/inventory_slot.tscn")

func _ready() -> void:
	Inventory.items_changed.connect(_update_display)
	_update_display()
	
func _update_display() -> void:
	print("Updating display, items: ", Inventory.items.size())
	for child in $HBoxContainer.get_children():
		child.queue_free()
		
	for item in Inventory.items:
		print("Adding slot for: ", item.item_name)
		var slot := slot_scene.instantiate()
		$HBoxContainer.add_child(slot)
		slot.set_item(item)

extends Node2D

var items: Array = []
var max_slots: int = 6

signal items_changed

func add_item(item: Item) -> bool:
	if items.size() >= max_slots:
		print("Inventory full!")
		return false
	items.append(item)
	print("Item added: ", item.item_name, " | Total: ", items.size())
	items_changed.emit()
	return true
		
func has_item(item_name: String) ->  bool:
	for item in items:
		if item.name == item_name:
			return true
	return false

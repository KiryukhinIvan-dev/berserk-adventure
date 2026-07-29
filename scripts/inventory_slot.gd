extends Control

func set_item(item: Item) -> void:
	if item and item.icon:
		$TextureRect.texture = item.icon

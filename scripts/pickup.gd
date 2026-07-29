extends Area2D

@export var item: Item

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if Inventory.add_item(item):
			
			$Sprite2D.visible = false
			$CollisionShape2D.set_deferred("disabled", true)
			
			$AudioStreamPlayer.play()
			
			await  $AudioStreamPlayer.finished
			queue_free()

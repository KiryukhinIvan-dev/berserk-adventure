extends Area2D

var speed: float = 500.0
var damage: int = 1
var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		return
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

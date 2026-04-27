extends CharacterBody2D

@export var health: int = 3
@export var chase_speed: float = 80.0

var player: Node2D = null

func _ready() -> void:
	add_to_group("enemy")
	$DetectionArea.body_entered.connect(_on_body_entered)
	$DetectionArea.body_exited.connect(_on_body_exited)
	
func _physics_process(_delta: float) -> void:
	if player:
		var dir: float = sign(player.global_position.x - global_position.x)
		velocity.x = dir * chase_speed
		$Sprite2D.scale.x =  abs($Sprite2D.scale.x) * sign(-dir)
	else:
		velocity.x = 0
		
	move_and_slide()
	print("Player: ", player, " | In range: ", $DetectionArea.has_overlapping_bodies())
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") or body is StaticBody2D:
		return
	print("Entered: ", body.name)
	if body.is_in_group("player"):
		player = body
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") or body is StaticBody2D:
		return
	if body.is_in_group("player"):
		player = null
	
func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
		
	

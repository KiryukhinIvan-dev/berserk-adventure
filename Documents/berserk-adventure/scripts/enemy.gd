extends CharacterBody2D

@export var health: int = 3
@export var chase_speed: float = 80.0

var player: Node2D = null
var attack_timer: float = 0
var aggro: bool = false  

func _ready() -> void:
	add_to_group("enemy")
	$DetectionArea.body_entered.connect(_on_body_entered)
	$DetectionArea.body_exited.connect(_on_body_exited)
	
func _physics_process(_delta: float) -> void:
	attack_timer -= _delta
	
	if player:
		# Преследуем если в зоне ИЛИ агро после удара
		var in_range: bool = $DetectionArea.has_overlapping_bodies()
		if in_range or aggro:
			var dir: float = sign(player.global_position.x - global_position.x)
			velocity.x = dir * chase_speed
			$Sprite2D.scale.x = abs($Sprite2D.scale.x) * sign(-dir)
			
			if global_position.distance_to(player.global_position) < 40 and attack_timer <= 0:
				if player.has_method("take_damage"):
					player.take_damage(1)
					attack_timer = 1.0
		else:
			velocity.x = 0
	else:
		velocity.x = 0
	
	move_and_slide()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") or body is StaticBody2D:
		return
	if body.is_in_group("player"):
		player = body
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") or body is StaticBody2D:
		return
	if body.is_in_group("player"):
		player = null
	
func take_damage(amount: int) -> void:
	health -= amount
	aggro = true
	if health <= 0:
		queue_free()
		
	

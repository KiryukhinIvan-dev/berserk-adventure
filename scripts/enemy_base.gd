class_name EnemyBase
extends CharacterBody2D

enum State { IDLE, CHASE, ATTACK, HURT, DEAD }

@export var max_health: int = 3
@export var chase_speed: float = 80.0
@export var attack_damage: int = 1
@export var attack_range: float = 60.0
@export var attack_cooldown: float = 1.0

var health: int
var state: State = State.IDLE
var player: Node2D = null
var aggro: bool = false
var attack_timer: float = 0.0

func _ready() -> void:
	health = max_health
	add_to_group("enemy")
	$DetectionArea.body_entered.connect(_on_body_entered)
	$DetectionArea.body_exited.connect(_on_body_exited)
	
func _physics_process(delta: float) -> void:
	attack_timer -= delta
	
	if state == State.DEAD:
		return
		
	match state:
		State.IDLE:
			velocity.x = 0
					
		State.CHASE:
			if player == null:
				var players := get_tree().get_nodes_in_group("player")
				if players.size() > 0:
					player = players[0]
				else:
					state = State.IDLE
				
			if player:
				var dir : float = sign(player.global_position.x - global_position.x)
				velocity.x = dir * chase_speed
				$Sprite2D.scale.x = abs($Sprite2D.scale.x) * sign(-dir)
				var dist: float = global_position.distance_to(player.global_position)
				if dist < attack_range and attack_timer <= 0:
					state = State.ATTACK
					
		State.ATTACK:
			velocity.x = 0
			_on_attack()
			state = State.CHASE
			
		State.HURT:
			state = State.CHASE
		
	move_and_slide()
	
func _on_attack() -> void:
	pass
	
func take_damage(amount: int) -> void:
	health -= amount
	aggro = true
	state = State.CHASE
	if health <= 0:
		state = State.DEAD
		queue_free()
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		state = State.CHASE
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null

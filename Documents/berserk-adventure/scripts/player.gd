extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: = -400.0
@export var attack_cooldown: = 0.4
@export var max_health: int = 10

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count: int = 0
var max_jumps: int = 2
var can_attack: bool = true
var health: int
var is_dead: bool = false
var last_facing: float = 1.0

var spear_scene: PackedScene = preload("res://scenes/spear.tscn")

func _ready() -> void:
	health = max_health
	add_to_group("player")
	print("Player added to group: ", is_in_group("player"))

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			jump_count = 1
		elif jump_count < max_jumps:
			velocity.y = jump_velocity
			jump_count += 1
			
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_just_pressed("attack") and can_attack:
		can_attack = false
		throw_spear()
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
		
	if direction != 0:
		$Sprite2D.scale.x = abs($Sprite2D.scale.x) * direction
		last_facing = direction
		
	move_and_slide()
	
func throw_spear() -> void:
	var spear := spear_scene.instantiate()
	get_parent().add_child(spear)
	spear.direction = Vector2(last_facing, 0)
	spear.global_position = global_position + Vector2(last_facing * 20, -50)
	spear.get_node("SpearSprite").scale.x = abs(spear.get_node("SpearSprite").scale.x) * last_facing
	
func take_damage(amount: int) -> void:
	health -= amount
	print("Player HP: ", health)
	if health <= 0:
		die()

func die() -> void:
	is_dead = true
	print("Player died")
	# Пока просто исчезает, потом добавим анимацию
	queue_free()

extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_velocity: float = -400.0
@export var attack_cooldown: float = 0.4
@export var max_health: int = 10

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count: int = 0
var max_jumps: int = 2
var can_attack: bool = true
var health: int
var is_dead: bool = false
var last_facing: float = 1.0
var spear_scene: PackedScene = preload("res://scenes/spear.tscn")
var damage_bonus: int = 0
var speed_bonus: float = 0
var health_bonus: int = 0
var near_door = null

enum State { IDLE, RUN, JUMP, FALL, ATTACK, DIE }
var current_state: State = State.IDLE

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	health = max_health
	add_to_group("player")
	Inventory.items_changed.connect(_on_items_changed)
	_on_items_changed()
	
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	
	change_state(State.IDLE)

func change_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.JUMP:
			animation_player.play("jump")
		State.FALL:
			animation_player.play("fall")
		State.ATTACK:
			animation_player.play("attack")
		State.DIE:
			animation_player.play("die")

func _physics_process(delta: float) -> void:
	if current_state == State.DIE:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0
	
	match current_state:
		State.IDLE:
			_state_idle()
		State.RUN:
			_state_run()
		State.JUMP:
			_state_jump()
		State.FALL:
			_state_fall()
		State.ATTACK:
			_state_attack()
		State.DIE:
			pass
	
	move_and_slide()

func _state_idle() -> void:
	velocity.x = move_toward(velocity.x, 0, speed)
	
	if not is_on_floor():
		change_state(State.FALL)
		return
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		jump_count = 1
		change_state(State.JUMP)
		return
	if Input.get_axis("left", "right") != 0:
		change_state(State.RUN)
		return
	if Input.is_action_just_pressed("attack") and can_attack:
		_start_attack()

func _state_run() -> void:
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * (speed + speed_bonus)
		last_facing = direction
	else:
		change_state(State.IDLE)
		return
	
	if not is_on_floor():
		change_state(State.FALL)
		return
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		jump_count = 1
		change_state(State.JUMP)
		return
	if Input.is_action_just_pressed("attack") and can_attack:
		_start_attack()

func _state_jump() -> void:
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * (speed + speed_bonus)
		last_facing = direction
	
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		velocity.y = jump_velocity
		jump_count += 1
		animation_player.play("jump")
	
	if velocity.y > 0:
		change_state(State.FALL)
		return

func _state_fall() -> void:
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * (speed + speed_bonus)
		last_facing = direction
	
	if is_on_floor():
		change_state(State.IDLE)
		return
	
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		velocity.y = jump_velocity
		jump_count += 1
		change_state(State.JUMP)
		return

func _state_attack() -> void:
	velocity.x = move_toward(velocity.x, 0, speed)

func _start_attack() -> void:
	can_attack = false
	change_state(State.ATTACK)
	throw_spear()
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	can_attack = true
	if current_state == State.ATTACK:
		if is_on_floor():
			change_state(State.IDLE)
		else:
			change_state(State.FALL)

func throw_spear() -> void:
	var spear := spear_scene.instantiate()
	get_parent().add_child(spear)
	spear.direction = Vector2(last_facing, 0)
	spear.global_position = global_position + Vector2(last_facing * 20, -50)
	spear.damage = 1 + damage_bonus
	spear.speed = 1200 + speed_bonus

func take_damage(amount: int) -> void:
	if current_state == State.DIE:
		return
	health -= amount
	print("Player HP: ", health)
	if health <= 0:
		change_state(State.DIE)
		velocity = Vector2.ZERO
		collision_layer = 0
		collision_mask = 0
		is_dead = true

func _input(event) -> void:
	if event.is_action_pressed("interact") and near_door:
		near_door.use()

func _on_items_changed() -> void:
	damage_bonus = Inventory.get_set_bonus("berserk")
	speed_bonus = damage_bonus * 20
	health_bonus = damage_bonus * 5
	max_health = 10 + health_bonus
	print("Berserk bonus: +", damage_bonus, " dmg, +", speed_bonus, " spd")

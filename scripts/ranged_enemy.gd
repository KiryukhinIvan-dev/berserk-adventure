extends EnemyBase

@export var shoot_range: float = 200.0
@export var shoot_cooldown: float = 2.0
var shoot_timer: float = 0.0

func _ready() -> void:
	super._ready()
	shoot_timer = shoot_cooldown
	attack_range = shoot_range

func _physics_process(delta: float) -> void:
	shoot_timer -= delta
	super._physics_process(delta)

func _on_attack() -> void:
	if shoot_timer <= 0:
		print("Ranged enemy shoots!")
		shoot_timer = shoot_cooldown
		attack_timer = attack_cooldown

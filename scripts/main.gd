extends Node2D

@onready var thunder_player: AudioStreamPlayer = $ThunderPlayer
@onready var thunder_timer: Timer = $ThunderTimer

const INITIAL_THUNDER_DELAY: float = 5.0
const MIN_THUNDER_DELAY: float = 10.0 
const MAX_THUNDER_DELAY: float = 30.0

func _ready() -> void:
	thunder_timer.wait_time = INITIAL_THUNDER_DELAY
	thunder_timer.start()

func _on_thunder_timer_timeout() -> void:
	thunder_player.play()
	_setup_next_thunder()
	
func _setup_next_thunder() -> void:
	var random_time = randf_range(MIN_THUNDER_DELAY, MAX_THUNDER_DELAY)
	thunder_timer.wait_time = random_time
	thunder_timer.start()
	
	

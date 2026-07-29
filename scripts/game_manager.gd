extends Node2D

signal game_paused
signal game_resumed

var is_paused: bool = false
var score: int = 0

func _ready() -> void:
	pass
	
func add_score(amount: int) -> void:
	score += amount
	print("score", score)
	
func pause_game() -> void:
	is_paused = true
	get_tree().paused = true
	game_paused.emit()
	
	
func resume_game() -> void:
	is_paused = false
	get_tree().paused = false
	game_resumed.emit()
	
	

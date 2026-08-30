extends Node

signal game_paused
signal game_resumed

var is_paused: bool = false
var score: int = 0

func _ready() -> void:
	hide_cursor()
	
func hide_cursor() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func show_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func add_score(amount: int) -> void:
	score += amount
	print("score:", score)
	
func pause_game() -> void:
	is_paused = true
	get_tree().paused = true
	game_paused.emit()
	
	
func resume_game() -> void:
	is_paused = false
	get_tree().paused = false
	game_resumed.emit()
	
func restart_game() -> void:
	score = 0
	print("Before clear: ", Inventory.items.size())
	Inventory.clear()
	print("After clear: ", Inventory.items.size())
	get_tree().paused = false
	get_tree().reload_current_scene()
	

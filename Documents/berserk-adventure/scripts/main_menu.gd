extends Control

func _ready() -> void:
	$VBoxContainer/Start.pressed.connect(_on_start_pressed)
	$VBoxContainer/Continue.pressed.connect(_on_continue_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)
	$VBoxContainer/Continue.disabled = true

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_continue_pressed() -> void:
	pass
	
func _on_quit_pressed() -> void:
	get_tree().quit()

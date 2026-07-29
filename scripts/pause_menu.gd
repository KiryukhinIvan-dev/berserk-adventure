extends Control

func _ready() -> void:
	hide()
	$ColorRect.position = Vector2.ZERO
	$VBoxContainer/Resume.pressed.connect(_on_resume_pressed)
	$VBoxContainer/Restart.pressed.connect(_on_restart_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if GameManager.is_paused:
			hide()
			GameManager.resume_game()
		else:
			show()
			GameManager.pause_game()
		
func _on_resume_pressed() -> void:
	hide()
	GameManager.resume_game()
	
func _on_restart_pressed() -> void:
	GameManager.resume_game()
	get_tree().reload_current_scene()
	
func _on_quit_pressed() -> void:
	get_tree().quit()

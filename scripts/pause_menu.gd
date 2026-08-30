extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	$ColorRect.position = Vector2.ZERO
	$VBoxContainer/Resume.pressed.connect(_on_resume_pressed)
	$VBoxContainer/Restart.pressed.connect(_on_restart_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)

func _exit_tree() -> void:
	GameManager.hide_cursor()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			GameManager.resume_game()
		else:
			show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GameManager.pause_game()
		
func _on_resume_pressed() -> void:
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameManager.resume_game()
	
func _on_restart_pressed() -> void:
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GameManager.restart_game()
	
func _on_quit_pressed() -> void:
	get_tree().quit()

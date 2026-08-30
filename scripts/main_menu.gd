extends Control

@onready var menu_music = $MenuMusic
@onready var intro_overlay = $IntroOverlay

var intro_active: bool = false
var finishing: bool = false

func _ready() -> void:
	GameManager.show_cursor()
	$VBoxContainer/Start.pressed.connect(_on_start_pressed)
	$VBoxContainer/Continue.pressed.connect(_on_continue_pressed)
	$VBoxContainer/Quit.pressed.connect(_on_quit_pressed)
	$VBoxContainer/Continue.disabled = true
	intro_overlay.visible = false
	menu_music.play()

func _on_start_pressed() -> void:
	if intro_active or finishing:
		return
	GameManager.hide_cursor()
	_start_intro()

func _start_intro() -> void:
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	intro_active = true
	$VBoxContainer/Start.disabled = true
	
	intro_overlay.visible = true
	$IntroOverlay/ColorRect.color.a = 0
	$IntroOverlay/IntroText.modulate.a = 0
	
	var tween_music = create_tween()
	tween_music.tween_property(menu_music, "volume_db", -20, 2.0)
	
	var fade_in = create_tween()
	fade_in.tween_property($IntroOverlay/ColorRect, "color:a", 1.0, 2.0)
	
	var text_in = create_tween()
	text_in.tween_property($IntroOverlay/IntroText, "modulate:a", 1.0, 3.5)
	
	# Ждём 10 секунд
	await get_tree().create_timer(10.0).timeout
	
	# Если за это время не нажали — финиш
	if intro_active:
		_finish_intro()

func _process(_delta: float) -> void:
	if intro_active and not finishing:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("skip"):
			_finish_intro()

func _finish_intro() -> void:
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	if finishing:
		return
	finishing = true
	intro_active = false
	
	var fade_out = create_tween()
	fade_out.tween_property(menu_music, "volume_db", -40, 1.5)
	await fade_out.finished
	menu_music.stop()
	
	var fade_in = create_tween()
	fade_in.tween_property($IntroOverlay/ColorRect, "color:a", 0.0, 1.0)
	await fade_in.finished
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_continue_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

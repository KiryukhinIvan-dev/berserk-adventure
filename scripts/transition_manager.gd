extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func go_to(scene_path: String) -> void:
	print("Пытаюсь загрузить: ", scene_path)
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("scene_path")

extends Area2D

@export var next_scene: String = "res://scenes/level_2_jungle.tscn"
@export var door_name : String = "door"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if $Label:
		$Label.visible = false
		
func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		if $Label:
			$Label.visible = true
		body.near_door = self
		
func _on_body_exited(body) -> void:
	if body.is_in_group("player"):
		if $Label:
			$Label.visible = false
		body.near_door = null
		
func use() -> void:
	get_tree().change_scene_to_file(next_scene)
	

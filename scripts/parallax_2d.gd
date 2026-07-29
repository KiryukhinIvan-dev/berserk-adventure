extends ParallaxBackground

@export var speed: float = 50.0

func _process(delta):
	scroll_offset.x -= speed * delta

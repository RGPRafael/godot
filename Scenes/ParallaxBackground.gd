extends ParallaxBackground

var scrooling_speed = 50

func _process(delta):
	scroll_offset.y += scrooling_speed * delta 
	pass

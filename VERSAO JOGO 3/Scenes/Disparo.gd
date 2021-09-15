extends Area2D
export var hit_bala = false
export var bala_velocidade = 1000
#func _on_Disparo_body_entered(body):
signal hit_disparo

func _process(delta):
	
	var mov = Vector2(1,0)
	position += mov.rotated(rotation) * bala_velocidade * delta
	
func _on_Disparo_area_entered(area):
	hit_bala = true
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hit_disparo")
	area.hide()   #<--- funciona
	queue_free() # remove o tiro
	#yield(get_tree().create_timer(0.2), "timeout") # Com este timer, os tiros seguintes param de funcionar
	if area != null:
		area.free()
	
func _on_Disparo_VisibilityNotifier2D_screen_exited():
	queue_free()
	

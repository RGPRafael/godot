extends Area2D
export var hit_bala = false
export var bala_velocidade = 1000
#func _on_Disparo_body_entered(body):


func _process(delta):
	
	var mov = Vector2(1,0)
	position += mov.rotated(rotation) * bala_velocidade * delta
	
func _on_Disparo_area_entered(area):
	hit_bala = true

	hide()  # Player disappears after being hit.
	$CollisionShape2D.set_deferred("disabled", true)
	area.hide()   #<--- funciona
	yield(get_tree().create_timer(0.2), "timeout")
	if area != null:
		area.free()


func _on_Disparo_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.








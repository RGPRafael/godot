extends Area2D
export var hit_bala = false
export var bala_velocidade = 1000
signal sinal_hit_bala
#func _on_Disparo_body_entered(body):

func _ready():
	add_to_group("Disparos")
	

func _process(delta):
	
	var mov = Vector2(1,0)
	position += mov.rotated(rotation) * bala_velocidade * delta
	
func _on_Disparo_area_entered(area):
	hit_bala = true
	hide()  # Player disappears after being hit.
	$CollisionShape2D.set_deferred("disabled", true)
	
	


func _on_Disparo_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.








extends Area2D


class_name Disparo

var speed
var base_damage
var tipo_disparo
#func _on_Disparo_body_entered(body):
signal hit_disparo(area)

var tipo_tiro

func is_Disparo():
	print('DISPAROKKKKKKK')


func set_speed():
	#print('set_speed:' , tipo_tiro)
	tipo_disparo = tipo_tiro
	speed = CenaPrincipal.disparo_data[tipo_tiro]["speed"]
	
	
func set_base_damage():
	base_damage = CenaPrincipal.disparo_data[tipo_tiro]["damage"]
	

func _ready():
	#connect("body_entered", Global.Player, "my_func", [body])
	set_speed()
	set_base_damage()
	CenaPrincipal._on_Player_emite_tiro(self)
	.connect("area_entered", self, "_on_Disparo_area_entered", [self])
	get_node("VisibilityNotifier2D").connect("screen_exited", self, "_on_Disparo_VisibilityNotifier2D_screen_exited")

func _process(delta):
	
	var mov = Vector2(1,0)
	position += mov.rotated(rotation) * speed * delta
	
func _on_Disparo_area_entered(area, t ):

	$CollisionShape2D.set_deferred("disabled", true)
	print(area.name, ' tiro detectacolisao ', t)
	emit_signal("hit_disparo", area , t)
	#queue_free() # remove o tiro
	
func _on_Disparo_VisibilityNotifier2D_screen_exited():
	queue_free()
	
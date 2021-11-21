extends Area2D
export var speed = 400  # How fast the player will move (pixels/sec).
export var tempo_parado_cantos = 5
var life  
var screen_size  # Size of the game window.
var bala
var bala_tipo_tiro
var pode_atirar =  false
#var velocity = Vector2()  # The player's movement vector.
 
export var fire_rate = 0.8
signal hit(area)

###################################################
var direction_IA
var IA_player_is_shooting 
var wait
###################################################



#https://www.reddit.com/r/godot/comments/e7nwbp/what_does_preload_and_load_does/
func _tiro(tipo_de_tiro):
	if tipo_de_tiro == 'Disparo1':
		bala = preload('res://Scenes/Tiros/Disparo1.tscn')

	elif tipo_de_tiro == 'Disparo':
		bala = preload('res://Scenes/Tiros/Disparo.tscn')
	
	bala_tipo_tiro = tipo_de_tiro


func _ready():
	CenaPrincipal.jogador_existe  = true
	CenaPrincipal.tipo_de_tiro_escolhido = bala_tipo_tiro
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	pass


###############################################################################
#
#	Player IA
#
###############################################################################



func is_colliding_IA(area):
	#look_at(area.position)
	#print(IA_player_is_shooting)
	look_at(area.get_global_position())
	if life != null and life > 0 and pode_atirar == true and area!= null:
		IA_player_is_shooting = true
		var bala_objeto = bala.instance()
		bala_objeto.tipo_tiro = bala_tipo_tiro

		bala_objeto.position = $SaidaDeTiro.get_global_position()
		bala_objeto.rotation_degrees = rotation_degrees
		get_parent().add_child(bala_objeto)
		#$AudioStreamPlayer2D.play()
		bala_objeto.sound()
		pode_atirar = false

		yield(get_tree().create_timer(0.3),'timeout')
		
		pode_atirar = true
		IA_player_is_shooting = false
###############################################################################
#
#		Player IA
#
###############################################################################
func start(VIDAS):
	#position = pos
	life = VIDAS
	show()
	$CollisionShape2D.disabled = false
	pode_atirar =  true


func _on_Player_area_entered(area):
	if life == 0:
		hide()  # Player disappears after being hit.
		$CollisionShape2D.set_deferred("disabled", true)

	emit_signal("hit", area)
	


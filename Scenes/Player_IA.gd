extends Area2D
export var speed = 400  # How fast the player will move (pixels/sec).
var life  
var screen_size  # Size of the game window.
var bala
var bala_tipo_tiro
var pode_atirar =  false
#var velocity = Vector2()  # The player's movement vector.
 
export var fire_rate = 0.5
signal hit(area)

###################################################
var IA_player     = CenaPrincipal.Player_IA
var direction_IA  = 1
var IA_player_mov

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
	#print('screen:', screen_size)
	print('IA_player', IA_player)
	hide()

func _process(delta):
	Player_IA(delta)




###############################################################################
#
#	Player IA
#
###############################################################################

func _on_Left_screen_exited():
	yield(get_tree().create_timer(3), "timeout")
	direction_IA = direction_IA * -1
	#print('enterleft' )

func _on_Rigth_screen_exited():
	yield(get_tree().create_timer(3), "timeout")
	direction_IA = direction_IA * -1 
	#print('enter rigth')
	
func Player_IA(delta):
	CenaPrincipal.posicao_jogador = global_position
	var velocity = Vector2()  # The player's movement vector.
	$Area_IA/CollisionPolygon2D.disabled = false
	#$Area_IA/CollisionShape2D.disabled = false
	velocity.x += direction_IA

	look_at($look_position.position)
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed 
		$AnimatedSprite.play()
		#$AudioStreamPlayer2D.play()
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "CAMINHAR"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0

		
	elif velocity.y != 0:
		$AnimatedSprite.animation = "UP"
		$AnimatedSprite.flip_v = velocity.y > 0
	
	else:
		$AnimatedSprite.stop()
		
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func is_colliding_IA(area):
	look_at(area.position)
	if life != null and life > 0 and pode_atirar == true and area!= null:
		
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
	


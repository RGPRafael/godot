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
var enemy_array = []
var inimigo_detectado
###################################################



#https://www.reddit.com/r/godot/comments/e7nwbp/what_does_preload_and_load_does/
func _tiro(tipo_de_tiro):
	if tipo_de_tiro == 'Disparo1':
		bala = preload('res://Scenes/Tiros/Disparo1.tscn')

	elif tipo_de_tiro == 'Disparo':
		bala = preload('res://Scenes/Tiros/Disparo.tscn')
	
	bala_tipo_tiro = tipo_de_tiro


func _ready():
	#get_parent().jogador_existe  = true
	get_parent().tipo_de_tiro_escolhido = bala_tipo_tiro
	screen_size = get_viewport_rect().size
	direction_IA  = 1
	wait = false
	hide()

func _process(delta):
	if get_parent().jogador_existe :
		if !wait: move_Player_IA(delta)
		if enemy_array.size() != 0:
			select_enemy()
			if  life != null and life > 0  and pode_atirar:
				just_shoot()
		else:
			inimigo_detectado = null



###############################################################################
#
#	Player IA
#
###############################################################################

func select_enemy ():
	var enemy_progress_array = [] # o quanto o inimigo andou no caminho ...
	for i in enemy_array:
		enemy_progress_array.append(self.global_position - i.global_position)
	
	var distancia_min = enemy_progress_array.min()
	var enemy_index = enemy_progress_array.find (distancia_min)
	inimigo_detectado = enemy_array[enemy_index]



func move_Player_IA(delta):
	get_parent().posicao_jogador = global_position
	var velocity = Vector2()  
	velocity.x += direction_IA

	look_at(self.get_global_position())
	if IA_player_is_shooting == false and rotation_degrees != -90 :
		 rotation_degrees = -90
		
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
	position.x = clamp(position.x, 150, screen_size.x-200) #retorna um valor entre o min e max ..
	position.y = clamp(position.y, 0, screen_size.y)


	if global_position.x == screen_size.x-200 or global_position.x == 150: 

		wait = true
		yield(get_tree().create_timer(tempo_parado_cantos), "timeout")
		direction_IA = direction_IA * -1 
		wait = false


func is_colliding_IA(area):
	enemy_array.append(area)

func is_not_colliding_IA(area):
	enemy_array.erase(area)


func just_shoot():
	#look_at(area.get_global_position())
	look_at(inimigo_detectado.get_global_position())
	IA_player_is_shooting = true
	var bala_objeto = bala.instance()
	bala_objeto.tipo_tiro = bala_tipo_tiro

	bala_objeto.position = $SaidaDeTiro.get_global_position()
	bala_objeto.rotation_degrees = rotation_degrees
	get_parent().add_child(bala_objeto)
	#$AudioStreamPlayer2D.play()
	pode_atirar = false

	yield(get_tree().create_timer(fire_rate),'timeout')
	
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
	get_parent().jogador_existe  = true


func _on_Player_area_entered(area):
	if life == 0:
		hide()  # Player disappears after being hit.
		$CollisionShape2D.set_deferred("disabled", true)

	emit_signal("hit", area)
	


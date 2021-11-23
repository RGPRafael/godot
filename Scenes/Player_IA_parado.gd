extends Area2D
export var speed = 400  # How fast the player will move (pixels/sec).
var life  
var screen_size  # Size of the game window.
var bala
var bala_tipo_tiro

#var velocity = Vector2()  # The player's movement vector.
 
export var fire_rate = 0.4
signal hit(area)

###################################################
var direction_IA
var IA_player_is_shooting 
var wait


var inimigo_detectado
var enemy_array = []
var pode_atirar =  true
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
	CenaPrincipal.posicao_jogador = global_position
	if enemy_array.size() != 0:
		select_enemy()
		if  life != null and life > 0  and pode_atirar:
			just_shoot()
	else:
		inimigo_detectado = null
	pass
###############################################################################
#
#		Player IA
#
###############################################################################

func select_enemy ():
	var enemy_progress_array = [] # o quanto o inimigo andou no caminho ...
	for i in enemy_array:
		enemy_progress_array.append(self.global_position - i.global_position)
	
	var distancia_min = enemy_progress_array.min()
	var enemy_index = enemy_progress_array.find (distancia_min)
	inimigo_detectado = enemy_array[enemy_index]


func just_shoot():
	look_at(inimigo_detectado.get_global_position())
	var bala_objeto = bala.instance()
	bala_objeto.tipo_tiro = bala_tipo_tiro
	bala_objeto.position = $SaidaDeTiro.get_global_position()
	bala_objeto.rotation_degrees = rotation_degrees
	get_parent().add_child(bala_objeto)
#	$AudioStreamPlayer2D.play()
	pode_atirar = false
	yield(get_tree().create_timer(fire_rate), "timeout")
	pode_atirar = true
	pass
	
func is_colliding_IA(area):
	#print('area.name', area.name)
	enemy_array.append(area)
	pass

func is_not_colliding_IA(area):
	enemy_array.erase(area)
	pass
	
	
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
	


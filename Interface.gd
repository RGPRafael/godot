extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
onready var hp_bar       = get_node("BarraDebaixo/HBoxContainer/BarradeVida")
onready var hp_bar_tween = get_node("BarraDebaixo/HBoxContainer/BarradeVida/Tween")

signal bar_is_low
signal desliga_tudo

var choose_weapon # avisa se esta no modo construcao
var tipo_de_tiro 
var Player_IA

var current_wave = 0 # Contador de onda

var input_usuario_ondas 

func _ready():
	get_node("BarraAlto/PlayPause").connect('mouse_entered', get_parent(), 'desliga_tiro')
	get_node("BarraAlto/PlayPause").connect('mouse_exited' , get_parent(), 'liga_tiro'   )
	
	get_node("BarraAlto/speed").connect('mouse_entered', get_parent(), 'desliga_tiro')
	get_node("BarraAlto/speed").connect('mouse_exited' , get_parent() , 'liga_tiro'  )
	
	get_node("BarraAlto/QUIT").connect('mouse_entered', get_parent(), 'desliga_tiro')
	get_node("BarraAlto/QUIT").connect('mouse_exited' , get_parent() , 'liga_tiro'  )
	
	get_node("Start").connect('mouse_entered', get_parent(), 'desliga_tiro')
	get_node("Start").connect('mouse_exited' , get_parent(), 'liga_tiro'   )
	
	#get_node("PlayPause").connect("pressed",get_parent(),'test_pause')
	
	connect("bar_is_low",get_parent(),"Verifica_barradevida")
	choose_weapon = false
	
	#Player_IA     = false
	connect("desliga_tudo", get_parent(), 'desliga_som')
	
	for i in get_tree().get_nodes_in_group('Botoes_tiro'):
		var t = i.get_name()
		i.connect('pressed',self,'iniciar_botao', [t])
		i.connect('mouse_entered', get_parent(), 'desliga_tiro')
		i.connect('mouse_exited' , get_parent() , 'liga_tiro'  )
		

func iniciar_botao(tipo):
	tipo_de_tiro = tipo
	choose_weapon = true


func _process(_delta):
	pass


##############################################################################################
## BARRA DE CIMA
##############################################################################################


func _on_Som_pressed():
	emit_signal("desliga_tudo")


func show_dead_inimigos(d):
	var s =  str(d)
	$BarraAlto/enemys_died.text = s

#setar botao como process para que ele nao pause a arvore toda
func play_pause():
	#print('entrou em play pause')
	#GameData.jogo_comecou = true
	#if mouse
	if get_tree().is_paused():
		get_tree().paused = false
	else :
		get_tree().paused = true
		
	

func _on_speed_pressed():
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
		#Engine.timescale = 2
	else:
		Engine.set_time_scale(2.0)


func _on_QUIT_pressed():
	print('quit')
	get_tree().change_scene("res://RAiZ.tscn")
	
	
##############################################################################################
## BARRA DE CIMA
##############################################################################################




##############################################################################################
## BARRA DE BAIXO
##############################################################################################

func qt_vida( life ):
	var s =  str(life)
	$BarraDebaixo/HBoxContainer/Quantidade.text = s
	

func update_score(score):
	$ScoreLabel.text = str(score)
	#$MessageLabel.show() 
	
func stop_bar():
	hp_bar.set_tint_progress("434c44")
	hp_bar_tween.stop(hp_bar)
	hp_bar_tween.reset(hp_bar)


func update_health_bar(base_health , d):
	#hp_bar_tween.interpole_property(node, parameter, start_value, end_value,  duration, transistion_type, easing_type)
	hp_bar_tween.interpolate_property(hp_bar,'value', hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	if base_health >= 80 : 
		hp_bar.set_tint_progress("fb0f41") 
	elif base_health <= 80 and base_health >= 25 : 
		hp_bar.set_tint_progress("e1be32")
	elif base_health < 25 and base_health > 0 :  
		hp_bar.set_tint_progress("ff8300")
	else :
		hp_bar.set_tint_progress("434c44")
		emit_signal("bar_is_low")
	
	$BarraDebaixo/HBoxContainer/hit.text = str(d)
	
	
func get_bar_value():
	return hp_bar.value
	
func prepare_bar(base_health):

	hp_bar_tween.interpolate_property(hp_bar,'value', hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	hp_bar.set_tint_progress("fb0f41")
	
	
func qt_inimigos(text):
	#$ADVICE.text = text
	$BarraAlto/ADVICE.text = text
	
	
func _Player_is_NOT_AI():
	Player_IA = false
	return Player_IA


func _Player_is_AI():
	Player_IA = true
	return Player_IA

##############################################################################################
## BARRA DE BAIXO
##############################################################################################


##############################################################################################

##############################################################################################


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	choose_weapon = false
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	
	yield($MessageTimer, "timeout")

	$MessageLabel.text = "AGAIN?!"
	$MessageLabel.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$Start.show()
	
	
func show_game_win():
	choose_weapon = false
	show_message("You Win")
	# Wait until the MessageTimer has counted down.
	
	yield($MessageTimer, "timeout")

	$MessageLabel.text = "AGAIN?!"
	$MessageLabel.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$Start.show()
	

func _on_Start_pressed():
	#if CenaPrincipal.choose_weapon == false: # avisa se esta no modo construcao
	$MessageLabel.text = 'Choose a Player'
	if Player_IA != null :
		#$Start.show()
		#$Waves.hide()
		CenaPrincipal.Player_IA = Player_IA
		escolha_arma()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func escolha_arma():
	if choose_weapon == false:
		$MessageLabel.text = 'Choose a weapon'

#	elif input_usuario_ondas == null : 
#		$MessageLabel.text = 'Set Waves:'
#		$Waves.show()
	
	else:

	
		if current_wave == 0:
			$Start.hide()
			emit_signal("start_game", tipo_de_tiro)
			print("wave 0")
		else:
			#var wave = AI.start_experiment()
			#start_next_wave_AI(wave)
			print("AI")
			
func start_next_wave_AI(wave): # roda quando da play e qd o player mata toda a onda
	yield(get_tree().create_timer(0.5), "timeout")#padding
#	spawn_enemies(wave)


func _on_Input_text_entered(new_text):

	input_usuario_ondas = new_text
	print('entrou em input text')
	#$Start.show()
	$Waves.hide()

#func qt_de_ondas_user():
#	return input_usuario_ondas
	

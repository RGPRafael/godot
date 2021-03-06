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
var tipo_IA
var main_scene


var save_path = "user://save.dat"

#var current_wave = 0 # Contador de onda

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
	
	get_node("Save").connect('mouse_entered', get_parent(), 'desliga_tiro')
	get_node("Save").connect('mouse_exited' , get_parent(), 'liga_tiro'   )
	
	get_node("Load").connect('mouse_entered', get_parent(), 'desliga_tiro')
	get_node("Load").connect('mouse_exited' , get_parent(), 'liga_tiro'   )
	
	#get_node("PlayPause").connect("pressed",get_parent(),'test_pause')
	
	.connect("start_game",get_parent(),'new_game')
	
	
	connect("bar_is_low",get_parent(),"Verifica_barradevida")
	choose_weapon = false
	
	#Player_IA     = false
	connect("desliga_tudo", get_parent(), 'desliga_som')
	
	for i in get_tree().get_nodes_in_group('Botoes_tiro'):
		var t = i.get_name()
		i.connect('pressed',self,'iniciar_botao', [t])
		i.connect('mouse_entered', get_parent(), 'desliga_tiro')
		i.connect('mouse_exited' , get_parent() , 'liga_tiro'  )
		
		
	main_scene = get_parent()

func iniciar_botao(tipo):
	tipo_de_tiro = tipo
	choose_weapon = true


func _process(_delta):
	pass


##############################################################################################
## BARRA DE CIMA
##############################################################################################
func _on_Save_pressed():
	var data = {
		'populacao' : AI.population,
		'geracao'   : ControleData.geracao,
	}
	var file = File.new()
	var error = file.open(save_path,File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
		
	
	pass # Replace with function body.


func _on_Load_pressed():  ## falra pegar de volta as informa????es e usar no jogo kk
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var output = file.get_var()
			file.close()
			print('load: ', output, '\n')
	pass # Replace with function body.


func _on_Som_pressed():
	emit_signal("desliga_tudo")


func show_dead_inimigos(d):
	var s =  str(d)
	$BarraAlto/enemys_died.text = s

#setar botao como process para que ele nao pause a arvore toda
func play_pause():

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
	


func show_geracao(s):
	$BarraAlto/Gen_result.text = str(s)
	
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
	#print('entreou em nao ia ')
	Player_IA = false
	ControleData.Player_IA = Player_IA
	_on_Start_pressed()


func _Player_is_AI():
	#print('entreou em ia vdd')
	Player_IA = true
	ControleData.Player_IA = Player_IA
	_on_Start_pressed()

func tipo_IA_move_atira():
	#print('entreou em ia move')
	tipo_IA = 1
	ControleData.tipo_IA = tipo_IA
	$A.hide()
	$B.hide()
	_on_Start_pressed()
	
func tipo_IA_parado():
	#print('entreou em ia parado')
	tipo_IA = 0
	ControleData.tipo_IA = tipo_IA
	$A.hide()
	$B.hide()
	_on_Start_pressed()

##############################################################################################
## BARRA DE BAIXO
##############################################################################################


##############################################################################################

##############################################################################################


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
	
##############################################################################################
#
# Modificando show_game over e show game win de tal maneira que o jogador fique fadado
# a usar o mesmo tiro ate morrer.. assim nao precisamos setar o tiro toda vez
# auxiliando na autma??ao dos testes..caso queiramos voltar para o antigo comportament0
# descomentar choose_weapon e $start.show()
#
###############################################################################################	

func show_game_over():
	#choose_weapon = false
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	
	yield($MessageTimer, "timeout")

	$MessageLabel.text = "AGAIN?!"
	$MessageLabel.show()
	
func show_game_win():
	show_message("You Win")
	
	yield($MessageTimer, "timeout")# Wait until the MessageTimer has counted down.

	$MessageLabel.text = "AGAIN?!"
	$MessageLabel.show()

	yield(get_tree().create_timer(5), "timeout") # Make a one-shot timer and wait for it to finish.
	$Start.show()
	#emit_signal("start_game", tipo_de_tiro)
	
##############################################################################################
#
# Modificando show_game over e show game win de tal maneira que o jogador fique fadado
# a usar o mesmo tiro ate morrer.. assim nao precisamos setar o tiro toda vez
# auxiliando na autma??ao dos testes..caso queiramos voltar para o antigo comportament0
# descomentar choose_weapon e $start.show()
#
###############################################################################################	


func _on_Start_pressed():

	if Player_IA == null:
		 $MessageLabel.text = 'Choose a Player'
		
	elif Player_IA == true and tipo_IA != null :
		$Start.show()
		escolha_arma()
		#$Start.show()
		#$Waves.hide()
		
	elif Player_IA == false:
		$Start.show()
		escolha_arma()
		
	elif Player_IA != null:
		$Start.hide()
		$A.show()
		$B.show()




func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func escolha_arma():
	#$Start.show()
	if choose_weapon == false:
		$MessageLabel.text = 'Choose a weapon'
	
	else:
		emit_signal("start_game", tipo_de_tiro)
		$Start.hide()


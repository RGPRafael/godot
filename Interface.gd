extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
onready var hp_bar       = get_node("BarraDebaixo/HBoxContainer/BarradeVida")
onready var hp_bar_tween = get_node("BarraDebaixo/HBoxContainer/BarradeVida/Tween")

signal bar_is_low


var choose_weapon # avisa se esta no modo construcao
var tipo_de_tiro 

func _ready():
	#$MessageLabel.text = 'OI'
	connect("bar_is_low",get_parent(),"Verifica_barradevida")
	choose_weapon = false
	for i in get_tree().get_nodes_in_group('Botoes_tiro'):
		var t = i.get_name()
		i.connect('pressed',self,'iniciar_botao', [t])
		

func iniciar_botao(tipo):
	#print('comecou o jogo')
	tipo_de_tiro = tipo
	#print(tipo_de_tiro)
	choose_weapon = true
	pass


func get_bar_value():
	return hp_bar.value
	
func prepare_bar(base_health):

	hp_bar_tween.interpolate_property(hp_bar,'value', hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	hp_bar.set_tint_progress("fb0f41")
	
	
func qt_vida( life ):
	var s =  str(life)
	$BarraDebaixo/HBoxContainer/Quantidade.text = s

	
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
	

##############################################################################################

##############################################################################################

func qt_inimigos(text):
	#$ADVICE.text = text
	$BarraAlto/ADVICE.text = text

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	
	yield($MessageTimer, "timeout")

	$MessageLabel.text = "AGAIN?!"
	$MessageLabel.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$Start.show()
	
	
func show_game_win():
	show_message("You Win")
	# Wait until the MessageTimer has counted down.
	
	yield($MessageTimer, "timeout")

	$MessageLabel.text = "AGAIN?!"
	$MessageLabel.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$Start.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	#$MessageLabel.show() 
		


func _on_Start_pressed():
	#if CenaPrincipal.choose_weapon == false: # avisa se esta no modo construcao
		
	if choose_weapon == false:
		
		#print('C')
		$MessageLabel.text = 'Choose your weapon first...'
	
	else:
		$Start.hide()
		emit_signal("start_game", tipo_de_tiro)


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


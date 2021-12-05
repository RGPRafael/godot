extends Node


#https://godotforums.org/discussion/20181/what-is-meant-by-packedscene-how-it-differ-from-normal-i-am-little-confused
#https://docs.godotengine.org/pt_BR/stable/classes/class_packedscene.html
#https://docs.godotengine.org/pt_BR/stable/getting_started/step_by_step/your_first_game.html#enemy-scene

var score
var Fases = 5
var rng

###########################################################################
#
# adaptando para a IA
#
###########################################################################




###########################################################################
#
# Variaveis relacionados ao Inimigo
#
###########################################################################
var inimigos_vivos = 0   # inimigos q vao sendo criados
var dead_inimigos
var geracao = 0
var posicao_base_randon = Vector2(600,-100)
var tamanho_tela = [0,1280]

var inimigo_atual # qt de inimigos instanciados

var dados_inimigos = [['inimigos', Vector2(90,-50)], 
					  ['inimigo1', Vector2(90,-50)], 
					  ['inimigo2', Vector2(90,-50)], 
					  ['inimigo3', Vector2(90,-50)], 
					  ['inimigo4', Vector2(-90,-50)], 
					  ['inimigos', Vector2(90,-50)] ]

#var dados_inimigos = [['inimigos',1], 
#					  ['inimigo1',1], 
#					  ['inimigo2',1], 
#					  ['inimigo3',1], 
#					  ['inimigo4',1], 
#					  ['inimigo5',1] ]
					
var num_inimigos = dados_inimigos.size()   # total de inimigos naquela fase 

var inimigos_data 
var input_user_text # quantidade de ondas que o usuario digitou q quer  enfrentar


###########################################################################
#
# Variaveis relacionados ao Inimigo
#
###########################################################################


###########################################################################
#
# Variaveis relacionados ao Player
#
###########################################################################

var can_damage = true
var posicao_jogador = Vector2()
#export var life_jogador = 3
var life_jogador = 3
export var base_health  = 100
var jogador_existe = false
var tipo_de_tiro_escolhido
var Player_IA
var Player
var tipo_IA
var disparo_data
var total_damage = 0

###########################################################################
#
# Variaveis relacionados ao Player
#
###########################################################################

###########################################################################
#
#
############################################################################


var Wave = []



###########################################################################
#
#
############################################################################
var construindo_inimigo = false

func _ready():
	rng = RandomNumberGenerator.new()
	disparo_data  = ControleData.disparo_data
	inimigos_data =  ControleData.inimigos_data
	randomize()
	pass

###########################################################################
#
# Funções do Player
#
###########################################################################

func player_damage(area):
	if can_damage:
		#wave_damage += damage
		total_damage += area.damage
		base_health = base_health - area.damage
		$HUD.update_health_bar(base_health , area.damage)
		

#### usado pela interface para mexer na barra de vida do player...
func Verifica_barradevida() :
	can_damage = false
	life_jogador = life_jogador - 1

	if life_jogador == 0:
		$HUD.qt_vida(life_jogador)
		Player.pode_atirar = false
		$ScoreTimer.stop()
		$HUD.show_game_over()
		$HUD.stop_bar()
		yield(get_tree().create_timer(4), "timeout")#padding
		get_tree().change_scene("res://Scenes/TUTOTIAL GODOT.tscn")
	
	else:
		base_health = 100
		$HUD.qt_vida(life_jogador)
		$HUD.prepare_bar(base_health)
		yield(get_tree().create_timer(0.5), "timeout")#padding

	Player.life = life_jogador
	can_damage = true


######################################################
#
###########################################################################



###########################################################################
#
# Funções do Inimigo
#
###########################################################################


func criando_inimigos():
	var new_population
	print('criando inimigos')
	if geracao == 0 :  start_first_wave()
	else : 
		new_population =  AI.start_experiment()
		start_next_wave(new_population)
	
func start_next_wave(wave): # roda quando da play e qd o player mata toda a onda
	yield(get_tree().create_timer(0.5), "timeout")#padding
	carrega_inimigos(wave)


func start_first_wave(): # roda quando da play 

	var wave = ControleData.inimigos_each
	print('first wave')
	print(wave)
	carrega_inimigos(wave)
	

func carrega_inimigos(wave):
	#test_result_waves += '; ' + str(wave_damage) + '\n'
	#wave_damage = 0
	geracao += 1
	$HUD.show_geracao(geracao)
	print(geracao, ' new_population', wave)
	
	for i in wave:
		var new_inimigo = load('res://Scenes/Inimigos/' + i[0] + ".tscn").instance()
		#new_inimigo.carregar_dados(i[0] , i[1], posicao_base_randon)
		#new_inimigo.random_position_x(tamanho_tela)
		
		new_inimigo.carregar_dados(i[0], i[1])
		new_inimigo.random_position()
		$Arvore_inimigos.add_child(new_inimigo)
		yield(get_tree().create_timer(new_inimigo.padding), "timeout")#padding
		inimigos_vivos += 1
		$HUD.qt_inimigos(str(inimigos_vivos))

	construindo_inimigo = false
	$HUD.show_message('...')
	yield(get_tree().create_timer(5), "timeout")#padding


func _process(_delta):
	if !construindo_inimigo and get_tree().get_nodes_in_group('inimigos').size() == 0 and geracao > 0 and life_jogador > 0:
		print('entrei no process')
		$HUD.show_geracao(geracao)
		construindo_inimigo = true
		criando_inimigos()

	
	
func show_death():
	dead_inimigos += 1
	$HUD.show_dead_inimigos(dead_inimigos)

###########################################################################
#
# Funções do Inimigo
#
###########################################################################




###########################################################################
#
# Funções de controle do jogo
#
###########################################################################

func desliga_tiro():
	#$Player.pode_atirar = false
	if Player != null: Player.pode_atirar = false
func liga_tiro():
	#$Player.pode_atirar = true
	if Player != null: Player.pode_atirar = true

	

func set_variaveis_globais():
	score = 0
	dead_inimigos = 0
	base_health = 100
	inimigos_vivos = 0

func desliga_som():
	#print('desliga-som')
	pass

func new_game(tipo_detiro):
	print('new_game')
	$ScoreTimer.start()
	inimigo_atual = 0
	if geracao == 0 and Player == null:
		Player_IA = ControleData.Player_IA
		tipo_IA  = ControleData.tipo_IA
		set_variaveis_globais()
		
		Player = Carrega_player()
		Player.position = $StartPosition.get_global_position()
		add_child(Player)
		Player.connect('hit' , self, 'player_damage' )
		Player._tiro(tipo_detiro)
		$HUD.update_score(score)
		$HUD.prepare_bar(base_health)
		$HUD.qt_vida(life_jogador)

	Player.start(life_jogador)
	$HUD.show_message("GET READY")
	$StartTimer.set_wait_time(2)
	$StartTimer.start()
	$HUD.show_message("GO!")
	start_first_wave()



func Carrega_player():
	#print('carregar player variavel IA:' , Player_IA)
	var Scene_player
	if Player_IA and tipo_IA == 1:
		Scene_player = preload("res://Scenes/Player_IA.tscn")
		
	elif Player_IA and tipo_IA == 0:
		Scene_player = preload("res://Scenes/Player_IA_parado.tscn")
		
	elif Player_IA == false :
		Scene_player = preload('res://Scenes/Player_user.tscn')


	return Scene_player.instance()


func game_over():
	pass
	

func game_win():
	print('win')
	Player.pode_atirar = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_win()
	


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)



###########################################################################
#
# Funções de controle do jogo
#
###########################################################################


###########################################################################
#
#
# Funçoes de ajuda para debug
#
###########################################################################
func debug_inimigos(_array):
	#guarda_inimigos()
	print('entrou em deboug_inimigos')
	var n =  get_node("Arvore_inimigos").get_children()

	for k in n:
		print('tipo_inimigo: ' , k.tipo_de_inimigo, ' ',
			  'speed:  ',  k.speed,           ' ',
			  'damage: ',  k.damage,          ' ',
			  'resist: ',  k.resist,          ' ',
			  'life    ',  k.life,            ' ',
			  'hit     ',  k.hit,             ' ', 
			  'id      ',  k.id ,             ' ',
			  'time:   ',  k.time_elapsed )
		k.queue_free()
		
		
# It is not using the default Godot directory ~/.local/share/godot/app_userdata
# Instead goes straight into ~/.local/share
# Probably related to the non-standart directory organization, needs fixing
func write_data(data):
	print('total_damage: ', total_damage)
	var path = 'user://ast_data.csv'
	var file = File.new()
	
	# All this to be able to append to file
	if file.file_exists(path):
		file.open(path, File.READ_WRITE)
		file.seek_end()
		file.store_string('; ')
	else:
		file.open(path, File.WRITE)
		
	file.store_string(str(data))
	file.close()







###########################################################################
#
#
# Funçoes de ajuda para debug
#
###########################################################################




##############################################################################
#
#
#
#
#
#
#############################################################################


func guarda_inimigos():
	print('entrou guarda_inimigos')
	#var inf = ['tipo' ,  'speed',  'damage', 'resist', 'life', 'hit', 'id']
	var asteroides =  get_node("Arvore_inimigos").get_children()
	for dado in asteroides:
		var array =	[dado.tipo_de_inimigo,
					['speed' , dado.speed ],
					['damage', dado.damage],
					['resist', dado.resist],
					['life'  , dado.life  ],
					['hit'   , dado.hit   ],
					['id'    , dado.id    ]]
		Wave.append(array)
		
		










##############################################################################
#
#
#
#
#
#
#############################################################################

extends Node

#
#https://gdscript.com/solutions/signals-godot/

signal game_finished(result)

var score

var posicao_base_randon = Vector2(600,-100)

###########################################################################
#
# Variaveis relacionados ao Player
#
###########################################################################

var can_damage = true
var posicao_jogador = Vector2()
#export var life_jogador = 3
var life_jogador 
var base_health  = 100
var jogador_existe = false
var tipo_de_tiro_escolhido
var Player_IA
var Player
var tipo_IA
var disparo_data

###########################################################################
#
# Variaveis relacionados ao Player
#
###########################################################################

#####################################################
#
# Nodes from Main
#
####################################################
var MobTimer
var ScoreTimer
var StartTimer
var StartPosition
var Interface
var Arvore_inimigos


#####################################################
#
# variaveis para controle do jogo
#
####################################################

var geracao  = 0
var inimigo_atual 
var num_inimigos    # total de inimigos naquela fase 
var tamanho_tela = [0,1280]
var array_inimigos = [] 
var inimigos_vivos = 0   # inimigos q vao sendo criados
var dead_inimigos
#####################################################
#
# testes variaveis
#
####################################################
var test_result_waves = ''
var test_players = 'players'
var test_enemies = 'ai'
var test_mode = false
var TEST_WAVES = 30 #30 waves de teste
var TEST_HEALTH = 9223372036854775807 # signed 64bit int
var wave_damage  = 0
var construindo_inimigo = false
var players_types = []
#####################################################
#
# testes variaveis
#
####################################################

#var wave

func player_damage(area):
	if can_damage:
		wave_damage  += area.damage
		
		base_health = base_health - area.damage
		Interface.update_health_bar(base_health , area.damage)
		
func Verifica_barradevida() :
	can_damage = false
	life_jogador = life_jogador - 1

	if life_jogador == 0:
		if !test_mode:
			Interface.qt_vida(life_jogador)
			ScoreTimer.stop()
			game_finished('over')
			emit_signal("game_finished", false)
		else:
			Interface.qt_vida(life_jogador)
			ScoreTimer.stop()
			game_finished('over')
	
	elif !test_mode: base_health = 100
		
	else:
		Interface.qt_vida(life_jogador)
		Interface.prepare_bar(base_health)
		yield(get_tree().create_timer(0.5), "timeout")#padding
	
	Player.life = life_jogador
	can_damage = true

func show_death():
	dead_inimigos += 1
	Interface.show_dead_inimigos(dead_inimigos)

# Called when the node enters the scene tree for the first time.
func _ready():
	MobTimer      = get_node("MobTimer")
	ScoreTimer    = get_node("ScoreTimer") 
	StartTimer    = get_node("StartTimer")
	StartPosition = get_node("StartPosition")
	Arvore_inimigos = get_node("Arvore_inimigos") 

	Interface = load('res://Scenes/Interface.tscn').instance()
	add_child(Interface)
	if test_mode: Interface.show_message('')
	
# Test mode parameters
# towers: 		'Player_IA_parado', 'Player_IA'...'
# enemies: 'AI', 'Random', 'All_inimigos','All_inimigo1', 'All_inimigo2', 'All_inimigo3', 'All_inimigo4'
func init_params(players, enemies):
	test_mode = true
	test_players = players
	test_enemies = enemies
	base_health = TEST_HEALTH



func Carrega_player():
	var Scene_player
	if Player_IA and tipo_IA == 1:
		Scene_player = preload("res://Scenes/Player_IA.tscn")
		
	elif Player_IA and tipo_IA == 0:
		Scene_player = preload("res://Scenes/Player_IA_parado.tscn")
		
	elif Player_IA == false :
		Scene_player = preload('res://Scenes/Player_user.tscn')

	return Scene_player.instance()
	
func Carrega_PlayerTiro(players_types):

	Player = load("res://Scenes/" + players_types[0] + ".tscn").instance()
	Player._tiro(players_types[1]) #SETA TIPO DE TIRO
	Player.connect('hit' , self, 'player_damage' )
	Player.position = StartPosition.get_global_position()
	add_child(Player)


func Set_Player_IA_AND_SHOOT(): 	#tipo_IA = 0 =>_IA_move_atira , tipo_IA = 1 => IA_parado

	match test_players:
		'IA_STILL _RED_SHOOT':
			players_types = ['Player_IA_parado', 'Disparo1']
		'IA_STILL_YELLOW_SHOOT':
			players_types = ['Player_IA_parado', 'Disparo']
		'IA_MOVING_SHOOTING_ RED_SHOOT':
			players_types = ['Player_IA', 'Disparo1']
		'IA_MOVING_ SHOOTING _YELLOW_SHOOT':
			players_types = ['Player_IA', 'Disparo']
			
	if   players_types[0] == 'Player_IA'  :      
		ControleData.tipo_IA = 0
		Interface.tipo_IA = 0
	elif players_types[0] == 'Player_IA_parado': 
		ControleData.tipo_IA = 1
		Interface.tipo_IA = 1
	
	Interface.Player_IA = true
	Interface.choose_weapon = true
	tipo_de_tiro_escolhido = players_types[1]
	
	Carrega_PlayerTiro(players_types)
	
func random_enemies():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var n = ControleData.inimigos_each.size()
	var enemy_list = []
	for _i in range(n):
		var item = ControleData.inimigos_each[randi() % n]
		enemy_list.append(item)
	
	return enemy_list 


func _process(_delta):
	if !construindo_inimigo and get_tree().get_nodes_in_group('inimigos').size() == 0 and geracao > 0 :
		print('entrei no process')
		construindo_inimigo = true
		criando_inimigos()
		


func criando_inimigos():
	var new_population
	print('criando inimigos')
	if test_mode:
		if geracao == TEST_WAVES:
			# Logs the last wave damage
			test_result_waves += str(wave_damage) + '\n'
			print('test_mode finish')
			write_file()
			Interface.show_game_over() 
			yield(get_tree().create_timer(5), "timeout")
			emit_signal("game_finished", false)
			return
		else:
			match test_enemies:
				'AI':
					new_population = AI.start_experiment()
				'Random':
					new_population = random_enemies()
				'All_inimigos':
					new_population = ControleData.inimigos
				'All_inimigo1':
					new_population = ControleData.inimigo1
				'All_inimigo2':
					new_population = ControleData.inimigo2
				'All_inimigo3':
					new_population = ControleData.inimigo3
				'All_inimigo4':
					new_population = ControleData.inimigo4
				'All_inimigo5':
					new_population = ControleData.inimigo5
				'One_EACH':
					new_population = ControleData.inimigos_each

			start_next_wave(new_population)
			
	elif !test_mode and geracao == 0 : 
		print('test mode falso')
		start_first_wave()

	else : 
		new_population = AI.start_experiment()
		print(new_population)
		start_next_wave(new_population)  

func start_next_wave(wave): # roda quando da play e qd o player mata toda a onda
	# Damage logging. The damage for the last wave is not logged here
	# Since it is written with a 1 wave delay. Added to the _process()
	if test_mode:
		test_result_waves += str(wave_damage) + '\n'
	yield(get_tree().create_timer(0.5), "timeout")#padding
	carrega_inimigos(wave)


func start_first_wave(): # roda quando da play 
	ScoreTimer.start()
	var wave = ControleData.inimigos_each
	match test_enemies:
		'AI':
			#wave = AI.start_experiment()
			wave = ControleData.inimigos_each
		'Random':
			wave = random_enemies()
		'All_inimigos':
			wave = ControleData.inimigos
		'All_inimigo1':
			wave = ControleData.inimigo1
		'All_inimigo2':
			wave = ControleData.inimigo2
		'All_inimigo3':
			wave = ControleData.inimigo3
		'All_inimigo4':
			wave = ControleData.inimigo4
		'All_inimigo5':
			wave = ControleData.inimigo5
		'One_EACH':
			wave = ControleData.inimigos_each
		
	yield(get_tree().create_timer(0.5), "timeout")#padding
	print('first wave')
	print(wave)
	carrega_inimigos(wave)
	
	
	
func carrega_inimigos(wave):

	geracao += 1
	Interface.show_geracao(geracao)
	# Test logging, saves wave number and the wave
	# Damage logging happens before, whena a new wave is called
	if test_mode:
		test_result_waves += str(geracao) + '; '
	for each in wave:
		test_result_waves += str(each) + '; '
			
	wave_damage = 0

	for i in wave:
		var new_inimigo = load('res://Scenes/Inimigos/' + i[0] + ".tscn").instance()
		#new_inimigo.carregar_dados(i[0] , i[1], posicao_base_randon)
		#new_inimigo.random_position_x(tamanho_tela)
		
		new_inimigo.carregar_dados(i[0], i[1])
		new_inimigo.random_position()
		Arvore_inimigos.add_child(new_inimigo)
		yield(get_tree().create_timer(new_inimigo.padding), "timeout")#padding
		inimigos_vivos += 1
		Interface.qt_inimigos(str(inimigos_vivos))

	construindo_inimigo = false


func game_finished(result):
	print('game finished' , result)
	Player.pode_atirar = false
	
	if result == 'win': Interface.show_game_win()
	elif result == 'over' :  
		print('result = over ')
		Interface.show_game_over() 
		Interface.stop_bar()

func _on_MobTimer_timeout():
	pass
		
func _on_StartTimer_timeout():
	pass

func set_variaveis_globais():
	score = 0
	dead_inimigos = 0
	base_health = 100
	inimigos_vivos = 0
	life_jogador = 3

func set_player_test():
	score = 0
	dead_inimigos = 0
	inimigos_vivos = 0
	life_jogador = 3

func set_interface():
	Interface.update_score(score)
	Interface.prepare_bar(base_health)
	Interface.qt_vida(life_jogador)

func new_game(tipo_de_tiro_escolhido):

	if geracao == 0 and Player == null:
		#print('player igual a null ')
		Player_IA = ControleData.Player_IA
		tipo_IA   = ControleData.tipo_IA
		set_variaveis_globais()
		
		Player = Carrega_player()
		Player.position = StartPosition.get_global_position()
		add_child(Player)
		Player.connect('hit' , self, 'player_damage' )
		
		Player._tiro(tipo_de_tiro_escolhido)
		
		set_interface()

	elif test_mode and geracao == 0: 
		#print('new_game test mode')
		set_player_test()
		set_interface()

	Interface.show_message("GO!!")
	Player.start(life_jogador)
	Interface.show_geracao(geracao)
	start_first_wave()


func _on_ScoreTimer_timeout():
	score += 1
	Interface.update_score(score)



# File writing at
#   Windows: %APPDATA%\Godot\
#   macOS: ~/Library/Application Support/Godot/
#   Linux: ~/.local/share/godot/
# Only in test mode
func write_file():
	var path = 'user://' + test_players + ' - ' + test_enemies + '.txt'
	var file = File.new()

	# All this to be able to append to file
	if file.file_exists(path):
		file.open(path, File.READ_WRITE)
		file.seek_end()
	else:
		file.open(path, File.WRITE)
	
	file.store_string(test_result_waves + '\n')
	file.close()

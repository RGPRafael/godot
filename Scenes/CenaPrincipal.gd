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
var geracao_atual
var posicao_base_randon = Vector2(600,-100)
var tamanho_tela = [0,1280]
#var current_wave = 0 # Contador de onda
var array_inimigos = [] 
var inimigo_atual # qt de inimigos instanciados

#var dados_inimigos = [['inimigos',1, Vector2(90,-50)], 
#					  ['inimigo1',1, Vector2(90,-50)], 
#					  ['inimigo2',1, Vector2(90,-50)], 
#					  ['inimigo3',1, Vector2(90,-50)], 
#					  ['inimigo4',1, Vector2(-90,-50)], 
#					  ['inimigos',1, Vector2(90,-50)] ]

var dados_inimigos = [['inimigos',1], 
					  ['inimigo1',1], 
					  ['inimigo2',1], 
					  ['inimigo3',1], 
					  ['inimigo4',1], 
					  ['inimigos',1] ]
					
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
var life_jogador 
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
		#area.hit = true # nao atualiza o hit do inimigo
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
		game_over()
	
	else:
		base_health = 100
		$HUD.qt_vida(life_jogador)
		$HUD.prepare_bar(base_health)
		yield(get_tree().create_timer(0.5), "timeout")#padding
	
	#$Player.life = life_jogador
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
	var new_population = []
	if geracao == 0 : new_population = dados_inimigos
	else            : new_population =  AI.start_experiment()
	
	print(geracao, ' new_population', new_population)
	
	for i in new_population :
		var s = 'res://Scenes/Inimigos/' + i[0] + ".tscn"
		var mob = load(s).instance()
		#mob.carregar_dados(i[0] , i[1], i[2])
		mob.carregar_dados(i[0] , i[1], posicao_base_randon)
		array_inimigos.append(mob) # 
		
	geracao +=1
	print('geracao:', geracao)
####################################
	ControleData.geracao = geracao 
####################################




################################################################################
# Ao implementar o pause a funcao add_inimigos_cena estava dando problema
# os inimigos ainda eram instanciados e colocados em cena porem nao se moviam
# depois do pause voltar os inimigos criados se moviem de novo... 
# comportamento aceitavel ? XD 
###############################################################################

func add_inimigos_cena():
	for mob in array_inimigos:
		get_node("Arvore_inimigos").add_child(mob)
		mob.position = Vector2(580, - 150)
		inimigos_vivos += 1
		yield(get_tree().create_timer(0.8), "timeout")#padding
		$HUD.qt_inimigos(str(inimigos_vivos))

func _on_MobTimer_timeout():
	
	if inimigo_atual < num_inimigos and Player.life > 0:
		var mob = array_inimigos[inimigo_atual]

		mob.random_position_x(tamanho_tela)
		get_node("Arvore_inimigos").add_child(mob)
		inimigos_vivos += 1
		
		$HUD.qt_inimigos(str(inimigos_vivos))
		inimigo_atual += 1
		#[tipo inimigo, 2, padding]
		$StartTimer.set_wait_time(mob.padding)

		$StartTimer.start()
		
	
	elif  inimigo_atual == num_inimigos and Player.life > 0:
		$StartTimer.stop()
		game_win()
	
	else:
		$StartTimer.stop()
		game_over()
	pass

func _on_StartTimer_timeout():
	#print('inimigo_index: ', inimigo_atual, ' start timer..:' , $StartTimer.get_wait_time() , ' mob timer: ', $MobTimer.get_wait_time())
	if Player.life > 0:
		$MobTimer.start()
		$ScoreTimer.start()
	#add_inimigos_cena()
	pass
	
	
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
	life_jogador = 3

func desliga_som():
	#print('desliga-som')
	pass

func new_game(tipo_detiro):
	print('new_game')
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
	criando_inimigos()
	$HUD.show_message("GET READY")
	#$Musicas/Ready.play()

	$StartTimer.set_wait_time(1)
	$StartTimer.start()
	
	$HUD.show_geracao(geracao)
	#add_inimigos_cena()
	


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

func clear_memory_and_copy_data():
	# Writes data and zeroes total damage
	write_data(total_damage)
	total_damage = 0
	array_inimigos.clear()
	
	var n =  get_node("Arvore_inimigos").get_children()
	for k in n:
		var data = []
		data.append(k.hit)   #reached goal
		data.append(k.resist/ k.hp_total )
		AI.population_res[k.id] = data
		#k.tipo_de_inimigo k.speed  k.damage k.resist k.life k.hit k.id
		k.free()


func game_over():
	#guarda_inimigos()
	#debug_inimigos(array_inimigos)
	

	Player.pode_atirar = false
	#$Musicas/Game_over_back.play()
	
	$ScoreTimer.stop()
	$MobTimer.stop()
	clear_memory_and_copy_data()
	$HUD.show_game_over()
	
	#$Musicas/Game_over.play()
	$HUD.stop_bar()
	#clear_memory_and_copy_data()
	

func game_win():
	#guarda_inimigos()
	print('win')
	Player.pode_atirar = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	clear_memory_and_copy_data()
	
	$HUD.show_game_win()
	#$Musicas/win.play()
	#clear_memory_and_copy_data()
	


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

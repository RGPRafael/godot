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
#var current_wave = 0 # Contador de onda
var array_inimigos = [] 
var inimigo_atual # qt de inimigos instanciados

var dados_inimigos = [['inimigos'] , ['inimigos'] , ['inimigos'], ['inimigos'], ['inimigos'] , ['inimigos']]
					  #['inimigos'] , ['inimigos'] , ['inimigos'], ['inimigos'], ['inimigos']]


var num_inimigos = dados_inimigos.size()   # total de inimigos naquela fase 

#var inimigos_data =  ControleData.inimigos_data
var inimigos_data = {
	"inimigos": {
		"damage": 20,
		"resist": 50,
		"speed" : 500},
		
	"inimigo1": {
		"damage": 45,
		"resist": 30,
		"speed" : 350},
		
	"inimigo2": {
		"damage": 50,
		"resist": 40,
		"speed" : 470},
		
	"inimigo3": {
		"damage": 60,
		"resist": 40,
		"speed" : 320},
		
	"inimigo4": {
		"damage": 20,
		"resist": 60,
		"speed" : 550},
}
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

#var disparo_data = ControleData.disparo_data
var disparo_data = {
	"Disparo": {
		"damage":15 ,
		"speed": 1200},
	
	"Disparo1": {
		"damage": 30,
		"speed": 600},
}
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
	randomize()
	pass

###########################################################################
#
# Funções do Player
#
###########################################################################

func player_damage(area):
	if 	can_damage:
		area.hit = true # nao atualiza o hit do inimigo
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
	if geracao == 0:
		for i in dados_inimigos :
			var s = 'res://Scenes/Inimigos/' + i[0] + ".tscn"
			var mob = load(s).instance()
			mob.tipo_de_inimigo = i[0]
			mob.speed  = inimigos_data[i[0]]["speed"]
			mob.damage = inimigos_data[i[0]]["damage"]
			mob.resist = inimigos_data[i[0]]["resist"]
			mob.id = AI.id()
			array_inimigos.append(mob) # 

	else:
		var new_population =  AI.start_experiment()
		print(geracao, ' new_population', new_population)
		for i in new_population :
			var s = 'res://Scenes/Inimigos/' + i[0] + ".tscn"
			var mob = load(s).instance()
			mob.tipo_de_inimigo = i[0]
			mob.speed  = inimigos_data[i[0]]["speed"]
			mob.damage = inimigos_data[i[0]]["damage"]
			mob.resist = inimigos_data[i[0]]["resist"]
			mob.id = AI.id()
			array_inimigos.append(mob) # 

	
	geracao +=1
	print(geracao)
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
		mob.position = $InimigoPosition_start.position
		inimigos_vivos += 1
		yield(get_tree().create_timer(0.8), "timeout")#padding
		$HUD.qt_inimigos(str(inimigos_vivos))
		
		
		
		
################################################################################
# Ao implementar o pause a funcao add_inimigos_cena estava dando problema
# os inimigos ainda eram instanciados e colocados em cena porem nao se moviam
# depois do pause voltar os inimigos criados se moviem de novo... 
# comportamento aceitavel ? XD 
###############################################################################

func _on_MobTimer_timeout():
	#print('entroue em mob timer..')

	if inimigo_atual < num_inimigos and Player.life > 0:
		#print('inimigo_atual: ', inimigo_atual)
		var mob = array_inimigos[inimigo_atual]
		#var x = randf_range(150.0, 1100.0)
		var x = rng.randf_range(200,1000)
		mob.position.x = x
		mob.position.y = $InimigoPosition_start.position.y
		get_node("Arvore_inimigos").add_child(mob)
		inimigos_vivos += 1
		yield(get_tree().create_timer(0.05), "timeout")#padding
		$HUD.qt_inimigos(str(inimigos_vivos))
		inimigo_atual += 1
		$StartTimer.start()
	
	elif  inimigo_atual == num_inimigos and Player.life > 0:
		$StartTimer.stop()
		game_win()
	
	else:
		$StartTimer.stop()
		game_over()
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
	#geracao = 0
	dead_inimigos = 0
	base_health = 100
	inimigos_vivos = 0
	life_jogador = 3
	inimigo_atual = 0

func desliga_som():
	print('desliga-som')

func new_game(tipo_detiro):


	Player_IA = ControleData.Player_IA
	set_variaveis_globais()
	criando_inimigos()
	$HUD.show_message("READY?")
	$Musicas/Ready.play()
	
	#print('entrando em player')


	if Player == null:	
		Player = Carrega_player()
		Player.position = $StartPosition.get_global_position()
		add_child(Player)
		Player.connect('hit' , self, 'player_damage' )
		#$Player._tiro(tipo_detiro)
		#$Player.start(life_jogador)
	
	Player._tiro(tipo_detiro)
	Player.start(life_jogador)
	
	
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.prepare_bar(base_health)
	$HUD.qt_vida(life_jogador)
	
	$HUD.show_geracao(geracao)
	#add_inimigos_cena()
	
#	input_user_text = $HUD.qt_de_ondas_user()
#	print(input_user_text)

func Carrega_player():
	#print('carregar player variavel IA:' , Player_IA)
	var Scene_player
	if Player_IA:
		Scene_player = preload("res://Scenes/Player_IA.tscn")
		
	elif Player_IA == false :
		Scene_player = preload('res://Scenes/Player.tscn')


	return Scene_player.instance()

func clear_memory_and_copy_data():
	array_inimigos.clear()
	
	var n =  get_node("Arvore_inimigos").get_children()
	for k in n:
		var data = []
		data.append(k.hit)   #reached goal
		data.append(k.time_elapsed)
		AI.population_res[k.id] = data
		#k.tipo_de_inimigo k.speed  k.damage k.resist k.life k.hit k.id
		k.queue_free()


func game_over():
	#guarda_inimigos()
	#debug_inimigos(array_inimigos)
	
	#$Player.pode_atirar = false
	Player.pode_atirar = false
	$Musicas/Game_over_back.play()
	
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
	$Musicas/Game_over.play()
	$HUD.stop_bar()
	clear_memory_and_copy_data()
	
	#print(Wave)

func game_win():
	#guarda_inimigos()
	#$Player.pode_atirar = false
	Player.pode_atirar = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	#debug_inimigos(array_inimigos)
	
	$HUD.show_game_win()
	$Musicas/win.play()
	clear_memory_and_copy_data()
	
	#print(Wave)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	#print('entroue em start timer..')
	if Player.life > 0:
		$MobTimer.start()
		$ScoreTimer.start()
	#add_inimigos_cena()
	pass


	
	
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

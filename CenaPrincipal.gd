extends Node


#https://godotforums.org/discussion/20181/what-is-meant-by-packedscene-how-it-differ-from-normal-i-am-little-confused
#https://docs.godotengine.org/pt_BR/stable/classes/class_packedscene.html
#https://docs.godotengine.org/pt_BR/stable/getting_started/step_by_step/your_first_game.html#enemy-scene

export (PackedScene) var inimigos
export (PackedScene) var inimigo1
export (PackedScene) var inimigo2
export (PackedScene) var inimigo3
export (PackedScene) var inimigo4

#signal colision(a,b)


var score

###########################################################################
#
# Variaveis relacionados ao Inimigo
#
###########################################################################
var num_inimigos = 10
var inimigos_vivos = 0
var dead_inimigos = 0
var geracao = 0
var array_inimigos = [] #vazio por q...
var inimigo_atual 

var dados_inimigos = [['inimigos'] , ['inimigo1'] , ['inimigo2'], ['inimigo3'], ['inimigo4']]

#var Mob_teste = preload('res://Scenes/Inimigos/inimigoteste.tscn')

var inimigos_data = {
	"inimigos": {
		"damage": 10,
		"resist": 50,
		"speed" : 210},
		
	"inimigo1": {
		"damage": 25,
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
var life_jogador
var base_health  = 100
var jogador_existe = false
var tipo_de_tiro_escolhido

#var choose_weapon = false # avisa se esta no modo construcao
#var tipo_de_tiro 
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


func _ready():
	randomize()
	pass

###########################################################################
#
# Funções do Player
#
###########################################################################

func player_damage(area):
	area.hit = true # nao atualiza o hit do inimigo
	if 	can_damage:
		
		base_health = base_health - area.damage
		$HUD.update_health_bar(base_health , area.damage)
	


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
	
	$Player.life = life_jogador
	can_damage = true


###########################################################################
#
# Funções do Player
#
###########################################################################



###########################################################################
#
# Funções do Inimigo
#
###########################################################################



func criando_inimigos():
	#print('criando_inimigos')
	var k = 0
	for _j in range(2):
		for i in dados_inimigos :
			var s = 'res://Scenes/Inimigos/' + i[0] + ".tscn"
			var mob = load(s).instance()
			mob.tipo_de_inimigo = i[0]
			mob.speed  = inimigos_data[i[0]]["speed"]
			mob.damage = inimigos_data[i[0]]["damage"]
			mob.resist = inimigos_data[i[0]]["resist"]
			mob.id = k
			array_inimigos.append(mob) # 
			k += 1
	#print('k inimgos criados:' , k)


func add_inimigos_cena():
	for mob in array_inimigos:
		get_node("Arvore_inimigos").add_child(mob)
		mob.position = $InimigoPosition_start.position
		inimigos_vivos += 1
		yield(get_tree().create_timer(0.8), "timeout")#padding
		$HUD.qt_inimigos(str(inimigos_vivos))

func _on_MobTimer_timeout():
	#print('entroue em mob timer..')
	#print('array_size_inimgo: ',array_inimigos.size())
	if inimigo_atual < num_inimigos:
		var mob = array_inimigos[inimigo_atual]
		mob.position = $InimigoPosition_start.position
		get_node("Arvore_inimigos").add_child(mob)
		inimigos_vivos += 1
		yield(get_tree().create_timer(0.2), "timeout")#padding
		$HUD.qt_inimigos(str(inimigos_vivos))
		inimigo_atual += 1
		$StartTimer.start()
	
	elif  inimigo_atual == num_inimigos and $Player.life > 0:
		$StartTimer.stop()
		game_win()
	
	else:
		$StartTimer.stop()
		game_over()
	pass


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

func new_game(tipo_detiro):
	print('entrou em new game')
	score = 0
	geracao = 0
	dead_inimigos = 0
	base_health = 100
	inimigos_vivos = 0
	life_jogador = 3
	inimigo_atual = 0
	criando_inimigos()
	$HUD.show_message("GET READY:")
	
	$Player._tiro(tipo_detiro)
	$Player.start($StartPosition.position,life_jogador)
	
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.prepare_bar(base_health)
	$HUD.qt_vida(life_jogador)
	#add_inimigos_cena()
	
	
func game_over():
	#print('entrou em game over')
	yield(get_tree().create_timer(2), "timeout")
	#print('game_over : ', array_inimigos.size())
	#debug_inimigos(array_inimigos)
	
	$Player.pode_atirar = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$HUD.stop_bar()
	array_inimigos.clear()
	var n =  get_node("Arvore_inimigos").get_children()
	for k in n:
		k.queue_free()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	#print('entroue em start timer..')
	$MobTimer.start()
	$ScoreTimer.start()
	#add_inimigos_cena()
	pass


func game_win():
	#print('entrou em game win')
	$Player.pode_atirar = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	#debug_inimigos(array_inimigos)
	$HUD.show_game_win()
	array_inimigos.clear()
	
	var n =  get_node("Arvore_inimigos").get_children()
	for k in n:
		k.queue_free()

	
	
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
func debug_inimigos(array):
	print('entrou em deboug_inimigos')
	print('tipo_inimigo ,  speed,  damage, resist, life,   hit ')
	var i = 0
	for j in array:
		print(j.tipo_de_inimigo,'        ',j.speed,'     ',j. damage,'      ',j.resist ,'     ', j.life,'   ' ,j.hit, ' inimigo: ',j.id )
		i +=1
	var n =  get_node("Arvore_inimigos").get_children()
	print()
	print('tipo_inimigo ,  speed,  damage, resist, life,   hit ')

	for k in n:
		print(k.tipo_de_inimigo,'        ',k.speed,'     ',k. damage,'      ',k.resist ,'     ', k.life,'   ' ,k.hit, ' inimigo: ',k.id )
		k.queue_free()
		
		








###########################################################################
#
#
# Funçoes de ajuda para debug
#
###########################################################################

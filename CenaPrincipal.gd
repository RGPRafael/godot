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
var num_inimigos = 50
var inimigos_vivos = 0
var dead_inimigos = 0
var damage = 20
var geracao = 0
var array_inimigos = []

var dados_inimigos = [['inimigos'] , ['inimigo1'] , ['inimigo2'], ['inimigo3'], ['inimigo4']]

var Mob_teste = preload('res://Scenes/Inimigos/inimigoteste.tscn')

var inimigos_data = {
	"inimigos": {
		"damage": 10,
		"resist": 50,
		"speed" : 210},
		
	"inimigo1": {
		"damage": 25,
		"resist": 100,
		"speed" : 250},
		
	"inimigo2": {
		"damage": 50,
		"resist": 90,
		"speed" : 170},
		
	"inimigo3": {
		"damage": 60,
		"resist": 80,
		"speed" : 220},
		
	"inimigo4": {
		"damage": 20,
		"resist": 90,
		"speed" : 150},
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
		"damage":5 ,
		"speed": 1200},
	
	"Disparo1": {
		"damage": 20,
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
	print('entrou em player_damage       ', 'n: ', area.name , 'd: ', area.damage)
	if 	can_damage:
		
		base_health = base_health - area.damage
		$HUD.update_health_bar(base_health , area.damage)


func _on_Player_emite_tiro(tiro):
	tiro.connect("hit_disparo", self, "_on_Disparo_hit_disparo")
	#tiro.connect("hit_disparo", self, "test")
	
func _on_Disparo_hit_disparo(area,  s):
	print('entrou em hit disparo' ,' ', s.name ,' ', area.name)
	#$HUD.update_score(dead_inimigos) #nao sei pq faz dar ruim
	if area.get_class() == "INIMIGO" :
		print(' ', area.resist , ' ', area.damage, ' ', area.speed)
		area.resist = area.resist - s.base_damage
		print('entrou no elif   ' , s.name, ' ' , s.base_damage , ' ',  area.resist) 
		s.queue_free()

func Verifica_barradevida() :
	print('entra em verfica')
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
func spawninimigos():
	
	for j in range(3):
		for i in dados_inimigos :
			var s = 'res://Scenes/Inimigos/' + i[0] + ".tscn"
			var mob = load(s).instance()
			mob.tipo_de_inimigo = i[0]
			mob.speed  = inimigos_data[i[0]]["speed"]
			mob.damage = inimigos_data[i[0]]["damage"]
			mob.resist = inimigos_data[i[0]]["resist"]
			mob.connect("area_entered", self, '_test', [mob]) 
			add_child(mob)
			mob.position = $InimigoPosition_start.position
			inimigos_vivos += 1
			yield(get_tree().create_timer(1), "timeout")#padding
			$HUD.qt_inimigos(str(inimigos_vivos))
			#print(mob.resist , mob.damage, mob.speed)


func _on_MobTimer_timeout():

	pass

func test1(area):
	print('test1')
	if area.name ==  'Player':
		print('          ', area.name)
	pass

func _test(area, s):

	#var p = s.get_type()  # so existe em godot 2 kkkk
	
	print('_test' )

	if area.name == 'Player':
		s.hide()  # Player disappears after being hit.
		s.desliga_colisao()
		print('                  ',  s.name)
		print('                  ', area.name)
		print('                  ', s.resist , ' ', s.damage, ' ', s.speed)
		CenaPrincipal.array_inimigos.append(s)
		
	#elif area.name == $Player.bala_tipo_tiro :
#	elif area.has_method("is_Disparo") :
#		print('                  ', s.resist , ' ', s.damage, ' ', s.speed)
#		s.resist = s.resist - area.base_damage
#		#s.fica_roxo() #meio q funciona o inimigo 2 ou 3 da pau 
#		print('entrou no elif   ' , area.name, ' ' , area.base_damage , ' ',  s.resist) 
#		area.queue_free()
	pass
	
	#print("HERE")

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
	score = 0
	geracao = 0
	dead_inimigos = 0
	base_health = 100
	inimigos_vivos = 0
	life_jogador = 3

	$HUD.show_message("GET READY:")
	
	$Player._tiro(tipo_detiro)
	$Player.start($StartPosition.position,life_jogador)
	
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.prepare_bar(base_health)
	$HUD.qt_vida(life_jogador)
	


func game_over():
	$Player.pode_atirar = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$HUD.stop_bar()
	get_tree().call_group("Grupo_Inimigos", "queue_free")


func _on_ScoreTimer_timeout():
	score += 1

func _on_StartTimer_timeout():
	#$MobTimer.start()
	#$ScoreTimer.start()
	spawninimigos()


func game_win():
	$ScoreTimer.stop()
	#$MobTimer.stop()
	$HUD.show_game_win()
	get_tree().call_group("Grupo_Inimigos", "queue_free")
	
	
###########################################################################
#
# Funções de controle do jogo
#
###########################################################################

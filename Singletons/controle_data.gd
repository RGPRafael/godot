extends Node


###########################################################################
#
# Variaveis relacionados ao Inimigo
#
###########################################################################
#var posiçoes_iniciais = 


var geracao
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
		
	"inimigo5": {
		"damage": 10,
		"resist": 120,
		"speed" : 900},
}

var locations= [ Vector2(90,-50), Vector2(200,-50), Vector2(500,-50), Vector2(800,-50), Vector2(1200,-50),
				 Vector2(-100,300), Vector2(-100,500), Vector2(-100,800), Vector2(-100,100), Vector2(-100,600),
				 Vector2(1350,300), Vector2(1350,100), Vector2(1350,-50), Vector2(1350,500), Vector2(1350,700),
				 Vector2(620,800), Vector2(1200,800), Vector2(1350,800), Vector2(100,800), Vector2(-50,800)]
				
var enemy_locations = PoolVector2Array( locations )
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


var Player_IA
var tipo_IA
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
# Variaveis relacionados aos Testes
#
###########################################################################


var inimigos_each = [['inimigos',1], ['inimigo1',1], ['inimigo2',1], ['inimigo3',1], ['inimigo4',1],['inimigo5',1]]
var inimigos = [['inimigos',1], ['inimigos',1], ['inimigos',1], ['inimigos',1], ['inimigos',1],['inimigos',1]]
var inimigo1 = [['inimigo1',1], ['inimigo1',1], ['inimigo1',1], ['inimigo1',1], ['inimigo1',1],['inimigo1',1]]
var inimigo2 = [['inimigo2',1], ['inimigo2',1], ['inimigo2',1], ['inimigo2',1], ['inimigo2',1],['inimigo2',1]]
var inimigo3 = [['inimigo3',1], ['inimigo3',1], ['inimigo3',1], ['inimigo3',1], ['inimigo3',1],['inimigo3',1]]
var inimigo4 = [['inimigo4',1], ['inimigo4',1], ['inimigo4',1], ['inimigo4',1], ['inimigo4',1],['inimigo4',1]]
var inimigo5 = [['inimigo5',1], ['inimigo5',1], ['inimigo5',1], ['inimigo5',1], ['inimigo5',1],['inimigo5',1]]
###########################################################################
#
# Variaveis relacionados aos Testes
#
###########################################################################

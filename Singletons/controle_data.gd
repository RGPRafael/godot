extends Node


###########################################################################
#
# Variaveis relacionados ao Inimigo
#
###########################################################################
#var posiçoes_iniciais = 


var geracao
var inimigos_data = {
	"inimigos": {  #BRANCO E PEQUENO
		"damage": 20,
		"resist": 50,
		"speed" : 500},
		
	"inimigo1": { # ESFERA VERMELHA
		"damage": 45,
		"resist": 30,
		"speed" : 350},
		
	"inimigo2": {
		"damage": 50,
		"resist": 40,
		"speed" : 470},
		
	"inimigo3": { # ESFERA AUL
		"damage": 60,
		"resist": 40,
		"speed" : 320},
		
	"inimigo4": { #ASTEROID GRANDE BRANCO
		"damage": 20,
		"resist": 60,
		"speed" : 550},
		
	"inimigo5": { # ESFERA AMARELA OU LARANJA 
		"damage": 10,
		"resist": 120,
		"speed" : 700},
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
	"Disparo": {  ## TIRO AMARELO BASTAO
		"damage":15 ,
		"speed": 1200},
	
	"Disparo1": {      # TIRO VERMELHO e GRANDE 
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


var inimigos_each = [['inimigos',Vector2(90,-50)  ], 
					 ['inimigo1',Vector2(-100,300)], 
					 ['inimigo2',Vector2(1350,100)], 
					 ['inimigo3',Vector2(-100,100)], 
					 ['inimigo4',Vector2(200,-50) ],
					 ['inimigo5',Vector2(1350,500)]]
					
var inimigos = [['inimigos',Vector2(-100,300)], 
				['inimigos',Vector2(-100,300)], 
				['inimigos',Vector2(-100,300)], 
				['inimigos',Vector2(-100,300)], 
				['inimigos',Vector2(-100,300)],
				['inimigos',Vector2(-100,300)]]
				
var inimigo1 = [['inimigo1',Vector2(1350,100)], 
				['inimigo1',Vector2(1350,100)], 
				['inimigo1',Vector2(1350,100)], 
				['inimigo1',Vector2(1350,100)],
				['inimigo1',Vector2(1350,100)],
				['inimigo1',Vector2(1350,100)]]
				
var inimigo2 = [['inimigo2',Vector2(-100,100)],
				['inimigo2',Vector2(-100,100)], 
				['inimigo2',Vector2(-100,100)], 
				['inimigo2',Vector2(-100,100)], 
				['inimigo2',Vector2(-100,100)],
				['inimigo2',Vector2(-100,100)]]
				
var inimigo3 = [['inimigo3', Vector2(200,-50)], 
				['inimigo3', Vector2(200,-50)], 
				['inimigo3', Vector2(200,-50)], 
				['inimigo3', Vector2(200,-50)], 
				['inimigo3', Vector2(200,-50)],
				['inimigo3', Vector2(200,-50)]]
				
var inimigo4 = [['inimigo4',Vector2(1350,500)], 
				['inimigo4',Vector2(1350,500)], 
				['inimigo4',Vector2(1350,500)], 
				['inimigo4',Vector2(1350,500)], 
				['inimigo4',Vector2(1350,500)],
				['inimigo4',Vector2(1350,500)]]
				
var inimigo5 = [['inimigo5',Vector2(1350,300)], 
				['inimigo5',Vector2(1350,300)], 
				['inimigo5',Vector2(1350,300)],
				['inimigo5',Vector2(1350,300)],
				['inimigo5',Vector2(1350,300)],
				['inimigo5',Vector2(1350,300)]]
###########################################################################
#
# Variaveis relacionados aos Testes
#
###########################################################################

extends Node

var score
var Fases = 5
var rng




###########################################################################
#
# Variaveis relacionados ao Inimigo
#
###########################################################################
var ondas 
var inimigos_vivos    # inimigos q vao sendo criados
var dead_inimigos
var geracao 
var geracao_atual
var array_inimigos 
var inimigo_atual # qt de inimigos instanciados

var dados_inimigos 
var num_inimigos 

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

var can_damage 
var posicao_jogador
var life_jogador
var base_health
var jogador_existe 
var tipo_de_tiro_escolhido
var Player_IA

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



extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Entrada do algoritmo:
################################################################################
#- Classe a instanciar (Script)
#- Tamanho da população a criar
#- Mapa de genes (String -> RNGs)
#- Critério (Measure)
##################################################################################

#Métodos:
################################################################################

#- população inicial (devolve população aleatória)
#- iterar população (recebe "resultado" da partida, devolve população "evoluída")

################################################################################


#Algoritmo em si
################################################################################
#NewEvolution(
# TDUnit,
#  10,
#  {
#	"melee_res": pick_random(RED, GREEN, BLUE),
#	"ranged_res": pick_random(RED, GREEN, BLUE)
#  },
#  LiveLongestMeasure.new()
#)
################################################################################

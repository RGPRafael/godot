extends Node2D

#
#https://gdscript.com/solutions/signals-godot/

signal game_finished(result)


#####################################################
#
# Nodes from Main
#
####################################################
var MOBTimer
var ScoreTimer
var StartTimer
var StartPosition
var Interface
var Arvores_inimigos


#####################################################
#
# Nodes from Main
#
####################################################

var build_mode = false # avisa se esta no modo construcao
var build_valid = false
var build_enemy = false
var build_type
var build_location
var build_tile

var base_health  = 100
var wave_damage = 0
var total_damage = 0 # Damage logging for statistical purposes
var onda_inimigos_atual = 0
# Automatic Test Mode variables
var test_result_waves = ''
var test_players = 'players'
var test_enemies = 'ai'
var test_mode = false
var TEST_WAVES = 30 # 30 waves de teste
var TEST_HEALTH = 9223372036854775807 # signed 64bit int

# Called when the node enters the scene tree for the first time.
func _ready():
	MOBTimer      = get_node("MobTimer")
	ScoreTimer    = get_node("ScoreTimer") 
	StartTimer    = get_node("StartTimer")
	StartPosition = get_node("StartPosition")
	Arvores_inimigos = get_node("Arvore_inimigos") 
	Interface = get_node("HUD")
	
		
# Test mode parameters
# towers: 		'AllGreen', 'AllRed', 'GreenRed', 'RedGreen'
# enemies: 'AI', 'Random', 'AllGreen', 'AllRed', 'AllBlue', 'AllGray', 'AllOrange'
func init_params(players, enemies):
	test_mode = true
	test_players = players
	test_enemies = enemies
	base_health = TEST_HEALTH

#######################################################################
#
#  Funções para construção de torres
#
########################################################################

func iniciar_botao(tipo_de_torre):

	if build_mode:
		cancel_build_mode()
	
	build_type = tipo_de_torre
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_position())

func update_tower_preview():
	pass
	
func cancel_build_mode():
	build_mode = false
	build_valid = false


func Set_Player_IA_AND_SHOOT():
	
	# Tested at locations (256, 448) and (640, 384)
	var tower_locations = PoolVector2Array()
	tower_locations = [Vector2(256, 448), Vector2(640, 384)]
	var players_types = []
	match test_players:
		'AllGreen':
			players_types = ['TowerGreen', 'TowerGreen']
		'AllRed':
			players_types = ['TowerRed', 'TowerRed']
		'GreenRed':
			players_types = ['TowerGreen', 'TowerRed']
		'RedGreen':
			players_types = ['TowerRed', 'TowerGreen']
	build_valid = true
	for i in range(tower_locations.size()):
		build_location = tower_locations[i]
		build_type = players_types[i]
		#verify_and_build()

#######################################################################
#
#  Função 'update'
#
########################################################################

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#######################################################################
#
#  Funções para inimigos
#
########################################################################

# File writing at
#   Windows: %APPDATA%\Godot\
#   macOS: ~/Library/Application Support/Godot/
#   Linux: ~/.local/share/godot/
# Only in test mode
func write_file(_dmg, _list_waves):
	pass


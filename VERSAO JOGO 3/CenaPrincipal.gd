extends Node


#https://godotforums.org/discussion/20181/what-is-meant-by-packedscene-how-it-differ-from-normal-i-am-little-confused
#https://docs.godotengine.org/pt_BR/stable/classes/class_packedscene.html
export (PackedScene) var Mob


var score
var geracao = 0
var num_inimigos = 5
var inimigos_atingidos = 0
var jogador_existe = false
var posicao_jogador = Vector2()
var player_life 


func _ready():
	randomize()


func verifica_inimigo():
	pass
	
	
	
func _process(delta):
	if inimigos_atingidos == 10:
		print("HERE")
		#$HUD.show_message("PROXIMA GERAcAO")
		inimigos_atingidos = 0
	
	pass
	

func game_over():
	player_life = $Player.life
	if player_life == 0:

		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
		get_tree().call_group("Grupo_Inimigos", "queue_free")
		
	$HUD.life(player_life)
	
	
	
func create_enemys():
	#var mob = Mob.instance()
	#$Arvore_inimigos.add_child(mob)
	#add_child(mob)
	#mob.position = $InimigoPosition_start.position
	
	
	for i in range(num_inimigos):
		var mob = Mob.instance()
		add_child(mob)
		mob.position = $InimigoPosition_start.position
		yield(get_tree().create_timer(0.5), "timeout")
		#mob.connect("area_entered", CenaPrincipal, "funciona")
	
	var enemies = get_tree().get_nodes_in_group("Grupo_Inimigos")
	print('enemys: ', enemies)
	pass
		

func new_game():

	score = 0
	player_life = 3
	$Player.start($StartPosition.position, player_life)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.life(player_life)
		
	$HUD.show_message("Get Ready")
	#$MobTimer.wait_time = 5
	create_enemys()
	
func _on_MobTimer_timeout():

	
	# Create a Mob instance and add it to the scene.
	
	#print("We are on gen: " + str(geracao))
	#for i in range(num_inimigos):
	#	var mob = Mob.instance()
	#	$Arvore_inimigos.add_child(mob)
	#	mob.position = $InimigoPosition_start.position

	#geracao += 1

	pass

func _on_ScoreTimer_timeout():
	#score += 1
	pass


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()



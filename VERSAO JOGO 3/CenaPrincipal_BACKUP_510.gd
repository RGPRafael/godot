extends Node


#https://godotforums.org/discussion/20181/what-is-meant-by-packedscene-how-it-differ-from-normal-i-am-little-confused
#https://docs.godotengine.org/pt_BR/stable/classes/class_packedscene.html
export (PackedScene) var Mob


var score
var geracao = 0
<<<<<<< HEAD
var num_inimigos = 5
var inimigos_atingidos = 0
=======
var num_inimigos = 10
var dead_inimigos = 0
>>>>>>> 998f2ef2d5bbc3c5a4e80d7855be725a0d88b446
var jogador_existe = false
var posicao_jogador = Vector2()
var player_life 


func _ready():
	randomize()

<<<<<<< HEAD

func verifica_inimigo():
	pass
	
	
	
func _process(delta):
	if inimigos_atingidos == 10:
		print("HERE")
		#$HUD.show_message("PROXIMA GERAcAO")
		inimigos_atingidos = 0
	
	pass
	

=======
>>>>>>> 998f2ef2d5bbc3c5a4e80d7855be725a0d88b446
func game_over():
	player_life = $Player.life
	if player_life == 0:

		$ScoreTimer.stop()
		#$MobTimer.stop()
		$HUD.show_game_over()
		get_tree().call_group("Grupo_Inimigos", "queue_free")
		
	$HUD.life(player_life)
	
	
	
func create_enemys():
	#var mob = Mob.instance()
	#$Arvore_inimigos.add_child(mob)
	#add_child(mob)
	#mob.position = $InimigoPosition_start.position
	
	
<<<<<<< HEAD
	for i in range(num_inimigos):
		var mob = Mob.instance()
		add_child(mob)
		mob.position = $InimigoPosition_start.position
		yield(get_tree().create_timer(0.5), "timeout")
		#mob.connect("area_entered", CenaPrincipal, "funciona")
	
	var enemies = get_tree().get_nodes_in_group("Grupo_Inimigos")
	print('enemys: ', enemies)
	pass
		

=======
>>>>>>> 998f2ef2d5bbc3c5a4e80d7855be725a0d88b446
func new_game():
	score = 0
<<<<<<< HEAD
	player_life = 3
	$Player.start($StartPosition.position, player_life)
=======
	geracao = 0
	dead_inimigos = 0
	$Player.start($StartPosition.position, 3)
>>>>>>> 998f2ef2d5bbc3c5a4e80d7855be725a0d88b446
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.life(player_life)
		
	$HUD.show_message("Get Ready")
<<<<<<< HEAD
	#$MobTimer.wait_time = 5
	create_enemys()
	
func _on_MobTimer_timeout():

=======
	
func _on_MobTimer_timeout():
	#print(posicao_jogador)
>>>>>>> 998f2ef2d5bbc3c5a4e80d7855be725a0d88b446
	
	# Create a Mob instance and add it to the scene.
	
	#print("We are on gen: " + str(geracao))
	#for i in range(num_inimigos):
	#	var mob = Mob.instance()
	#	$Arvore_inimigos.add_child(mob)
	#	mob.position = $InimigoPosition_start.position
<<<<<<< HEAD

	#geracao += 1

	pass
=======
	var mob = Mob.instance()
	#$Arvore_inimigos.add_child(mob)
	add_child(mob)
	mob.position = $InimigoPosition_start.position
	geracao += 1
	if geracao == num_inimigos:
		$MobTimer.stop()
>>>>>>> 998f2ef2d5bbc3c5a4e80d7855be725a0d88b446

func _on_ScoreTimer_timeout():
	#score += 1
	pass

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

<<<<<<< HEAD

=======
func _on_Player_emite_tiro():
	var tiro = get_node("Disparo")
	tiro.connect("hit_disparo", self, "_on_Disparo_hit_disparo")
	
func _on_Disparo_hit_disparo():
	dead_inimigos += 1
	var s =  'Killed : ' + str(dead_inimigos)
	$HUD.show_message(s)
	if dead_inimigos == num_inimigos:
		game_win()
	
func game_win():
	$ScoreTimer.stop()
	#$MobTimer.stop()
	$HUD.show_game_win()
	get_tree().call_group("Grupo_Inimigos", "queue_free")
>>>>>>> 998f2ef2d5bbc3c5a4e80d7855be725a0d88b446

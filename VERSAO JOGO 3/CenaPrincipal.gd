extends Node


#https://godotforums.org/discussion/20181/what-is-meant-by-packedscene-how-it-differ-from-normal-i-am-little-confused
#https://docs.godotengine.org/pt_BR/stable/classes/class_packedscene.html
export (PackedScene) var Mob


var score
var geracao = 0
var num_inimigos = 10
var jogador_existe = false
var posicao_jogador = Vector2()


func _ready():
	randomize()


func game_over():
	var life = $Player.life
	if life == 0:

		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
		get_tree().call_group("Grupo_Inimigos", "queue_free")
		
	else : 
		var s =  'Life : ' + str(life)
		$HUD.show_message(s)
	
	

func new_game():

	score = 0

	$Player.start($StartPosition.position, 3)
	$StartTimer.start()
	$HUD.update_score(score)
		
	$HUD.show_message("Get Ready")
	
	
	
func _on_MobTimer_timeout():
	print(posicao_jogador)
	
	# Create a Mob instance and add it to the scene.
	
	#print("We are on gen: " + str(geracao))
	#for i in range(num_inimigos):
	#	var mob = Mob.instance()
	#	$Arvore_inimigos.add_child(mob)
	#	mob.position = $InimigoPosition_start.position


	var mob = Mob.instance()
	#$Arvore_inimigos.add_child(mob)
	add_child(mob)
	mob.position = $InimigoPosition_start.position

	geracao += 1



func _on_ScoreTimer_timeout():
	score += 1


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()



func _on_Player_emite_tiro():
	#print('tiro')

	pass # Replace with function body.

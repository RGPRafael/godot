extends Node


#https://godotforums.org/discussion/20181/what-is-meant-by-packedscene-how-it-differ-from-normal-i-am-little-confused
#https://docs.godotengine.org/pt_BR/stable/classes/class_packedscene.html
export (PackedScene) var Mob


var score
var geracao = 0
var num_inimigos = 50
var inimigos_vivos = 0
var dead_inimigos = 0
var jogador_existe = false
var posicao_jogador = Vector2()
var base_health  = 100
var damage = 20
var life_jogador
var can_damage = true


func _ready():
	randomize()
	




func player_damage():
	if 	can_damage:
		print("can_damage")
		base_health = base_health - damage
		$UI.update_health_bar(base_health)
	
func new_game():
	score = 0
	geracao = 0
	dead_inimigos = 0
	base_health = 100
	inimigos_vivos = 0
	life_jogador = 3
	$Player.start($StartPosition.position,life_jogador)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	$UI.prepare_bar(base_health)
	$UI.qt_vida(life_jogador)
		
	
	
func Verifica_barradevida() :
	print("Verifica_barradevida")
	can_damage = false
	life_jogador = life_jogador - 1

	if life_jogador == 0:
		$UI.qt_vida(life_jogador)
		game_over()
	
	else:
		base_health = 100
		$UI.qt_vida(life_jogador)
		$UI.prepare_bar(base_health)
		yield(get_tree().create_timer(0.5), "timeout")#padding
	
	$Player.life = life_jogador
	can_damage = true

func game_over():
	$Player.pode_atirar = false
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$UI.stop_bar()
	get_tree().call_group("Grupo_Inimigos", "queue_free")


func _on_MobTimer_timeout():
	#print(posicao_jogador)
	
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
	inimigos_vivos += 1
	if inimigos_vivos == num_inimigos:
		$MobTimer.stop()

func _on_ScoreTimer_timeout():
	score += 1

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

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

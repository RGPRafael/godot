extends Node

# Called when the node enters the scene tree for the first time.
signal comeca_teste
func _ready():
	load_test_menu()
	
func load_test_menu():
	$TestMenu/Players/PlayersChoice.set_pressed(true)
	$TestMenu/enemies/AI.set_pressed(true)
	$TestMenu/buttons/TestMode.connect("pressed",self,"test_mode_pressed")
	$TestMenu/buttons/Return.connect("pressed",self,"return_main")
	#self.connect('comeca_teste',get_parent(),'test_start') 
	
func test_mode_pressed():
	print('test_mode_pressed')
	#var enemies = get_params()
	#CenaPrincipal.init_params(enemies)
	#emit_signal("comeca_teste")
	var params = get_params()
	var players = params[0]
	var enemies = params[1]
	get_node("TestMenu").queue_free()
	var scene = load('res://Scenes/Testes/Main_TESTMODE.tscn').instance()
	#scene.connect("game_finished",self, 'unload_game')
	scene.init_params(players, enemies)
	add_child(scene)
	if players != 'PlayersChoice':
		scene.Set_Player_IA_AND_SHOOT()
		print('set_player and shoot')
		
		
func return_main():
	
	get_node("TestMenu").queue_free()
	get_tree().change_scene("res://Scenes/TUTOTIAL GODOT.tscn")

# Getter for Test Mode parameters
func get_params():
	var players = $TestMenu/Players/PlayersChoice.get_button_group().get_pressed_button().get_name()
	var enemies = $TestMenu/enemies/AI.get_button_group().get_pressed_button().get_name()
	print( [players, enemies] )
	return [players, enemies]

func unload_game(result):
	get_node("MainScene").queue_free()
	get_tree().change_scene("res://Elements/TestMode.tscn")

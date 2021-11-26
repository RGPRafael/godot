extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_menu()
	
func load_main_menu():
	get_node("Menu/botoes/NewGame").connect("pressed",self,"new_game_pressed")
	get_node("Menu/botoes/TestMode").connect("pressed",self,"test_mode")
	get_node("Menu/botoes/Quit").connect("pressed",self,"quit_pressed")	
	
func new_game_pressed():
	get_node("Menu").queue_free()
	var scene = load('res://Elements/MainScene.tscn').instance()
	scene.connect("game_finished",self, 'unload_game')
	add_child(scene)
	
func test_mode():
	get_node("Menu").queue_free()
	get_tree().change_scene("res://Elements/TestMode.tscn")
	
func unload_game(result):
	get_node("MainScene").queue_free()
	var test_menu = load('res://Elements/GerenciarCena.tscn').instance()
	add_child(test_menu)

	
func quit_pressed():
	get_tree().quit()

extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_menu()
	
func load_main_menu():
	get_node("Menu/botoes/NewGame").connect("pressed",self,"new_game_pressed")
	get_node("Menu/botoes/TestMode").connect("pressed",self,"test_mode")
	get_node("Menu/botoes/Quit").connect("pressed",self,"quit_pressed")	
	
func new_game_pressed():
	get_node("Menu").queue_free()
	var scene = load('res://Scenes/Main_PlayerMode.tscn').instance()
	#scene.connect("game_finished",self, 'unload_game')
	add_child(scene)
	var interface = load('res://Scenes/Interface.tscn').instance()
	get_node('Main').add_child(interface)
	
func test_mode():
	get_node("Menu").queue_free()
	var t = load("res://Scenes/Testes/TestMode.tscn").instance()
	add_child(t)
	
func unload_game(result):
	get_node("MainScene").queue_free()
	var test_menu = load('res://Scenes/TUTOTIAL GODOT.tscn').instance()
	add_child(test_menu)

	
func quit_pressed():
	get_tree().quit()

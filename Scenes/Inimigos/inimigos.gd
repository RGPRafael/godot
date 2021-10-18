extends Area2D

# Called when the node enters the scene tree for the first time.
class_name INIMIGO

var v = Vector2.ZERO

var tipo_de_inimigo
var id
var speed = 500  # speed 
var damage
var resist



func _set_data(d):
	print(d)

func _ready():
	#self.monitoring = true
	#.connect("area_entered", self, "detecta_colisao") # nao esta funcionando nao sei pq ..
	print('entra no readyinimigo')
	print(tipo_de_inimigo) #ta dando null...
	#speed = CenaPrincipal.inimigos_data[tipo_de_inimigo]["speed"]
	v = global_position.direction_to(CenaPrincipal.posicao_jogador)
	var node_visibility = get_node('VisibilityNotifier2D')
	node_visibility.connect('screen_exited', self, '_on_VisibilityNotifier2D_screen_exited')


func detecta_colisao():
	print("HRERE")
	pass

func move(delta):
	position += v * speed * delta

func _process(delta):
	if CenaPrincipal.jogador_existe != false :
		move(delta)
	

# fazer os inimigo se autodestruirem ao sair da tela
func _on_VisibilityNotifier2D_screen_exited():
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
	pass # Replace with function body.

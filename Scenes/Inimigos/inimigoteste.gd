extends Area2D
var v = Vector2.ZERO

var tipo_de_inimigo
var id
var speed = 500  # speed 
var damage
var resist



func _set_data(d):
	print(d)

func _ready():
	#.connect("area_entered",self, 'detecta_colisao') #isso funciona
	connect("area_entered",get_parent(),'test1')
	v = global_position.direction_to(CenaPrincipal.posicao_jogador)
	var node_visibility = get_node('VisibilityNotifier2D')
	node_visibility.connect('screen_exited', self, '_on_VisibilityNotifier2D_screen_exited')


func detecta_colisao(area): # tem que receber um arg
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


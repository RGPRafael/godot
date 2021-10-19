extends Area2D

# Called when the node enters the scene tree for the first time.
class_name INIMIGO

var v = Vector2.ZERO

var tipo_de_inimigo
var id
var speed 
var damage
var resist
var life 
var array_inimigos = [] 
#var em_cena = false

func get_class(): #override
	return 'INIMIGO'
	
func get_class_name(): #override
	return 'INIMIGO'

func desliga_colisao():
	$CollisionShape2D.set_deferred("disabled", true)

func _set_data(d):
	print(d)

func _ready():
	life = true
	#connect("area_entered",get_parent(),'test1')
	#.connect("area_entered",self, 'detecta_colisao') #isso funciona
	v = global_position.direction_to(CenaPrincipal.posicao_jogador)
	var node_visibility = get_node('VisibilityNotifier2D')
	node_visibility.connect('screen_exited', self, '_on_VisibilityNotifier2D_screen_exited')


func detecta_colisao(area):
	print('detecta_colisao')
	if area.name == 'Player':
		hide()  # Player disappears after being hit.
		$CollisionShape2D.set_deferred("disabled", true)
		print('                  ',  name)
		print('                  ', area.name)
		print('                  ', resist , ' ', damage, ' ', speed)
		#CenaPrincipal.array_inimigos.append(self)
		array_inimigos.append(self)
	pass


func check_live():
	if resist <= 0 :
		hide()  # Player disappears after being hit.
		$CollisionShape2D.set_deferred("disabled", true)
		life = false
		#CenaPrincipal.array_inimigos.append(self)
		array_inimigos.append(self)


func move(delta):
	position += v * speed * delta

func _process(delta):
	if CenaPrincipal.jogador_existe != false :
		move(delta)
		check_live()
	

# fazer os inimigo se autodestruirem ao sair da tela
func _on_VisibilityNotifier2D_screen_exited():
	yield(get_tree().create_timer(0.2), "timeout")
	#CenaPrincipal.array_inimigos.append(self)
	array_inimigos.append(self)
	pass # Replace with function body.

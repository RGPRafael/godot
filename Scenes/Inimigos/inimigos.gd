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
var hit   # acertou ou nao o jogador
#var em_cena = false

func get_class(): #override
	return 'INIMIGO'
	
func get_class_name(): #override
	return 'INIMIGO'

func desliga_colisao():
	hide()  # Player disappears after being hit.
	$CollisionShape2D.set_deferred("disabled", true)

func change_color():
	$Sprite.modulate = Color('ff2400')

func _ready():
	life = true
	hit = null
	
	v = global_position.direction_to(CenaPrincipal.posicao_jogador)
	var node_visibility = get_node('VisibilityNotifier2D')
	node_visibility.connect('screen_exited', self, '_on_VisibilityNotifier2D_screen_exited')
	.connect("area_entered",self,'_hit')

func _hit(area):
	if area.name == 'Player':
		desliga_colisao()
		hit = true
		#print('entrou na func turn_of_hit - player ')
	
	elif area.has_method('is_Disparo'):
		resist = resist - area.base_damage
		change_color()
		area.queue_free()
		#print('entrou na func turn_of_hit - disparo ', area.name)
		
func check_live():
	if resist <= 0 :
		hide()  # Player disappears after being hit.
		$CollisionShape2D.set_deferred("disabled", true)
		life = false


func move(delta):
	position += v * speed * delta

func _process(delta):
	if CenaPrincipal.jogador_existe != false :
		move(delta)
		check_live()
	
func _on_VisibilityNotifier2D_screen_exited():
	#yield(get_tree().create_timer(0.1), "timeout")
	if hit == null: hit =  false
	pass

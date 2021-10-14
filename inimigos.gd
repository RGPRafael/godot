extends Area2D


export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.
var v = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	v = global_position.direction_to(CenaPrincipal.posicao_jogador)
	var node_visibility = get_node('VisibilityNotifier2D')
	node_visibility.connect('screen_exited', self, '_on_VisibilityNotifier2D_screen_exited')
	#$AnimatedSprite.play()
	
func move(delta):
	position += v * rand_range(min_speed, max_speed) * delta

func _process(delta):
	if CenaPrincipal.jogador_existe != false :
		move(delta)
	

# fazer os inimigo se autodestruirem ao sair da tela
func _on_VisibilityNotifier2D_screen_exited():
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
	pass # Replace with function body.

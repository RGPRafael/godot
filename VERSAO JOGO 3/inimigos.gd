extends Area2D


export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.
<<<<<<< HEAD

export var life = false
export var atingido = false
signal inimigo_atingido
var dogde = false

var v =  Vector2.ZERO
=======
var v = Vector2.ZERO
>>>>>>> 998f2ef2d5bbc3c5a4e80d7855be725a0d88b446
	


# Called when the node enters the scene tree for the first time.
func _ready():
	life =  true
	pass


func _physics_process(delta):
	if CenaPrincipal.jogador_existe != false :
		v = global_position.direction_to(CenaPrincipal.posicao_jogador)
	position += v * rand_range(min_speed, max_speed) * delta
	if dogde == true :
		position += v * 1000 * delta
	dogde = false

# fazer os inimigo se autodestruirem ao sair da tela
func _on_VisibilityNotifier2D_screen_exited():
	yield(get_tree().create_timer(0.2), "timeout")
	life = false



func _on_inimigos_area_entered(area):
	if area.is_in_group("Disparos"):
		print("QISSO")
		life = false
		atingido = true
		modulate = Color(0.639216, 0.039216, 0.039216)
		CenaPrincipal.inimigos_atingidos += 1
	
	elif area.name == 'Player':
		print('FLAMENGO')
		modulate = Color(0.206207, 0.398693, 0.910156)
		CenaPrincipal.inimigos_atingidos += 1
	
	elif area.is_in_group("Grupo_Inimigos"):
		print('BATI_EM MIM MESMo')
		modulate =Color(0.883193, 0.898438, 0.410614)
		dogde = true
		
	print(get_index())
	

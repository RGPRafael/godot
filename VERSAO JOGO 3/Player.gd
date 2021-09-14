extends Area2D
export var speed = 400  # How fast the player will move (pixels/sec).
var life  
var screen_size  # Size of the game window.
export var bala_velocidade = 1000
var bala =  preload("res://Scenes/Disparo.tscn")

var pode_atirar =  false
export var fire_rate = 0.5

signal emite_tiro
signal hit

func _ready():
	CenaPrincipal.jogador_existe  = true
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	CenaPrincipal.posicao_jogador = global_position
	var velocity = Vector2()  # The player's movement vector.
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("shoot") and pode_atirar:
		var bala_objeto = bala.instance()
		#bala_objeto.position = position
		bala_objeto.position = $SaidaDeTiro.get_global_position()
		#bala_objeto.rotation = rotation
		bala_objeto.rotation_degrees = rotation_degrees
		#bala_objeto.apply_impulse(Vector2(), Vector2(bala_velocidade, 0).rotated(rotation)) 

		get_tree().get_root().add_child(bala_objeto)
		
		pode_atirar = false
		emit_signal('emite_tiro')
		yield(get_tree().create_timer(fire_rate),'timeout')
		pode_atirar = true
		#bala_objeto.free()

		
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "CAMINHAR"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0

		
	elif velocity.y != 0:
		$AnimatedSprite.animation = "UP"
		$AnimatedSprite.flip_v = velocity.y > 0
	
	else:
		$AnimatedSprite.stop()
		
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	


#func _on_Player_body_entered(_body):

	
	
func start(pos, VIDAS):
	position = pos
	life = VIDAS
	show()
	$CollisionShape2D.disabled = false
	pode_atirar =  true

#func _on_Player_body_entered(_body):



func _on_Player_area_entered(_area):
	if life == 0:
		hide()  # Player disappears after being hit.
		$CollisionShape2D.set_deferred("disabled", true)
	else: 	
		life = life - 1
	emit_signal("hit")


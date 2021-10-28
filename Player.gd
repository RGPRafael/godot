extends Area2D
export var speed = 700  # How fast the player will move (pixels/sec).
var life  
var screen_size  # Size of the game window.
var bala
var bala_tipo_tiro 

var pode_atirar =  false
export var fire_rate = 0.5

signal hit(area)


#https://www.reddit.com/r/godot/comments/e7nwbp/what_does_preload_and_load_does/
func _tiro(tipo_de_tiro):
	if tipo_de_tiro == 'Disparo1':
		bala = preload('res://Scenes/Tiros/Disparo1.tscn')

	elif tipo_de_tiro == 'Disparo':
		bala = preload('res://Scenes/Tiros/Disparo.tscn')
	
	bala_tipo_tiro = tipo_de_tiro


func _ready():
	CenaPrincipal.jogador_existe  = true
	CenaPrincipal.tipo_de_tiro_escolhido = bala_tipo_tiro
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	
	CenaPrincipal.posicao_jogador = global_position
	var velocity = Vector2()  # The player's movement vector.
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("shoot") and pode_atirar:
		var bala_objeto = bala.instance()
		bala_objeto.tipo_tiro = bala_tipo_tiro

		bala_objeto.position = $SaidaDeTiro.get_global_position()
		bala_objeto.rotation_degrees = rotation_degrees
		get_parent().add_child(bala_objeto)
		#$AudioStreamPlayer2D.play()
		bala_objeto.sound()
		pode_atirar = false

		yield(get_tree().create_timer(fire_rate),'timeout')
		
		pode_atirar = true

		
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
		#$AudioStreamPlayer2D.play()
	
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
	


func start(pos, VIDAS):
	position = pos
	life = VIDAS
	show()
	$CollisionShape2D.disabled = false
	pode_atirar =  true


func _on_Player_area_entered(area):
	if life == 0:
		hide()  # Player disappears after being hit.
		$CollisionShape2D.set_deferred("disabled", true)

	emit_signal("hit", area)
	

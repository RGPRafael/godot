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
var in_scene

var floating_text = preload('res://Scenes/Pop up.tscn')
var particle = preload("res://Scenes/Inimigos/Particles2D.tscn")
#var particle_Bool = false

#measure how much time the enemy survived
var time_start
var time_elapsed

signal killed
var dead_inimigos 

func get_class(): #override
	return 'INIMIGO'
	
func get_class_name(): #override
	return 'INIMIGO'

func desliga_colisao():
	hide()  # Player disappears after being hit.
	$CollisionShape2D.set_deferred("disabled", true)

func show_text(dano):
	var text = floating_text.instance()
	text.dano = dano
	add_child(text)
	
	


func _ready():
	life = true
	hit = false
	in_scene = true
	v = global_position.direction_to(CenaPrincipal.posicao_jogador)
	var node_visibility = get_node('VisibilityNotifier2D')
	.connect('killed',get_parent().get_parent(),'show_death',[],4) #isso é mt safadeza
	node_visibility.connect('screen_exited', self, '_on_VisibilityNotifier2D_screen_exited')
	node_visibility.connect('screen_exited', self, '_on_VisibilityNotifier2D_screen_exited')
	.connect("area_entered",self,'_hit')
	
	var node_flash = get_node('FlashTimer')
	node_flash.connect('timeout',self, 'FlashTimer_timeout')
	node_flash.set_wait_time(0.9)
	
	time_start = OS.get_unix_time()

func _hit(area):
	#particle_Bool = true
	if area.name == 'Player':
		desliga_colisao()
		hit = true

	
	elif area.has_method('is_Disparo') :
		resist = resist - area.base_damage
		show_text(area.base_damage)
		
		flash() # animação adicionada
		
		#var p = particle.instance()
		
		#p.set_position(area.take_position())
		#p.set_emitting(true)
		#add_child(p)
#		#particle_Bool = false
		
		area.queue_free()

		
func check_life():
	if resist <= 0 :
		hide()  # Player disappears after being hit.
		$CollisionShape2D.set_deferred("disabled", true)
		#emit_signal('atualizar_score')
		life = false
		hit = false
		var time_now = OS.get_unix_time()
		time_elapsed = time_now - time_start
		emit_signal("killed")


func move(delta):
	position += v * speed * delta

func _process(delta):
	if CenaPrincipal.jogador_existe != false :
		move(delta)
		check_life()
	if in_scene:
		var time_now = OS.get_unix_time()
		time_elapsed = time_now - time_start
	
func _on_VisibilityNotifier2D_screen_exited():
	#yield(get_tree().create_timer(0.1), "timeout")
	if hit == null: hit =  false
	var time_now = OS.get_unix_time()
	time_elapsed = time_now - time_start
	pass
	
	
func flash():
	$Sprite.material.set_shader_param("flash_modifier",1)
	$FlashTimer.start()


func FlashTimer_timeout():
	$Sprite.material.set_shader_param("flash_modifier",0)

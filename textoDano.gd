extends Position2D


onready var label = get_node("Label")
onready var tween = get_node("Tween")

var dano       = 0
var velocidade = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(str(dano)) 
	randomize()
	var side_mov = randi()%81 - 40
	velocidade = Vector2(side_mov, 50)
	tween.interpolate_property(self, 'scale', scale, Vector2(1,1), 0.2 , Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', Vector2(1,1), Vector2(0.1,0.1), 0.9 , Tween.TRANS_LINEAR, Tween.EASE_OUT,0.3)
	tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position -= velocidade * delta
	pass


func _on_Tween_tween_all_completed():
	self.queue_free()
	pass # Replace with function body.

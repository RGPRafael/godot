extends CanvasLayer

# Called when the node enters the scene tree for the first time.
onready var hp_bar       = get_node("ColorRect/HBoxContainer/BarradeVida")
onready var hp_bar_tween = get_node("ColorRect/HBoxContainer/BarradeVida/Tween")

signal bar_is_low

func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_bar_value():
	return hp_bar.value
	
func prepare_bar(base_health):

	hp_bar_tween.interpolate_property(hp_bar,'value', hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	hp_bar.set_tint_progress("fb0f41")
	
	
func qt_vida( life ):
	var s =  str(life)
	$ColorRect/HBoxContainer/Quantidade.text = s

	
func stop_bar():
	hp_bar.set_tint_progress("434c44")
	hp_bar_tween.stop(hp_bar)
	hp_bar_tween.reset(hp_bar)


func update_health_bar(base_health):
	#hp_bar_tween.interpole_property(node, parameter, start_value, end_value,  duration, transistion_type, easing_type)
	hp_bar_tween.interpolate_property(hp_bar,'value', hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	if base_health >= 80 : 
		hp_bar.set_tint_progress("fb0f41") 
	elif base_health <= 80 and base_health >= 25 : 
		hp_bar.set_tint_progress("e1be32")
	elif base_health < 25 and base_health > 0 :  
		hp_bar.set_tint_progress("ff8300")
	else :
		hp_bar.set_tint_progress("434c44")
		emit_signal("bar_is_low")
		


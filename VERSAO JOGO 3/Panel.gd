extends Panel

func _ready():
	get_node("Button").connect("pressed", self, "_on_Button_pressed")


func _on_Button_pressed():
	#get_node("TimerExample").visible = true

	get_tree().change_scene("res://Scenes/TUTOTIAL GODOT.tscn")

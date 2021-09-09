extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	
	yield($MessageTimer, "timeout")

	$MessageLabel.text = "AGAIN?!"
	$MessageLabel.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$Start.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	#$MessageLabel.show() 
		


func _on_Start_pressed():
	$Start.hide()
	#vidas = 1 
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


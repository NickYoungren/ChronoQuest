extends CanvasLayer

var message_label: Label # Declare message_label variable

	

#func _on_player_death():
	#message_label = get_node("message_label")
	#message_label.text = "You died!"
	#message_label.show()


func _on_player_victory():
	message_label = get_node("message_label")
	message_label.text = "You won!"
	message_label.show()

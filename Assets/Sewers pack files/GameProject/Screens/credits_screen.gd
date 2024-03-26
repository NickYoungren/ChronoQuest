extends Node2D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextNode.position.y -= 1





func _on_button_back_button_down():
	get_tree().change_scene_to_file("res://Screens/start_screen.tscn")

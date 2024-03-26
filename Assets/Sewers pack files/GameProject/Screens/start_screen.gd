extends Control





func _on_button_thanks_button_down():
	get_tree().change_scene_to_file("res://Screens/credits_screen.tscn")


func _on_button_start_button_down():
	get_tree().change_scene_to_file("res://Levels/level.tscn")


func _on_link_button_down():
	OS.shell_open("https://www.patreon.com/ansimuz")

extends Node2D

func _ready():
	#Utils.saveGame()
	Utils.loadGame()

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	ChangeScene.change_scene("res://scenes/world.tscn")

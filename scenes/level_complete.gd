extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_next_pressed():
	print(Game.level)
	if Game.level == 2:
		ChangeScene.change_scene("res://scenes/room.tscn")
	elif Game.level >= 3:
		ChangeScene.change_scene("res://scenes/2floor.tscn")


func _on_back_pressed():
	ChangeScene.change_scene("res://scenes/Game.tscn")

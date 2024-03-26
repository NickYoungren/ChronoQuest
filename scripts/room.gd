extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#var playerpos = get_parent().get_node("Player").position
	#print(str(playerpos) + "\n")





func _on_sensor_body_entered(body):
	var door = get_node("door")
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(door, "position", Vector2(0, 120), 0.5)

extends Node2D


# Called when the node enters the scene tree for the first time.
func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Screen exited")
	queue_free()


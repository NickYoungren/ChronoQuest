extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.Gold >= 15:
		set_visible(true)
	pass

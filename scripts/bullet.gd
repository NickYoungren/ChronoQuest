extends Area2D
var speed = 700
var dir = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setDir(d):
	dir = d
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta * dir
	
func _on_body_entered(body):
	if body.get_parent().name == "mobs":
		body.stun()
	queue_free()

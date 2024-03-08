extends Area2D





func _on_body_entered(body):
	if body.name == "Player":
		get_node(NodePath("../../Player")).goldCount += 1
		self.queue_free()


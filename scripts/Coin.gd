extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		Game.Gold += 5
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0,25), .35)
		tween1.tween_property(self, "modulate:a", 0, .2)
		
		tween.tween_callback(queue_free)

extends Area2D

var speed := 500
var direction := Vector2(1, 0)

func _physics_process(delta):
	position.x += speed * delta * direction.x

func spawn_hit():
	var hit = preload("res://Common/HitFeedback/hit_feedback.tscn").instantiate()
	hit.global_position = global_position
	get_tree().get_root().call_deferred("add_child", hit)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	area.owner.kill()
	spawn_hit()
	queue_free()


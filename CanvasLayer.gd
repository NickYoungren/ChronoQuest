extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await($AnimationPlayer)
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards('dissolve')

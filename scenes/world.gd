extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hud_start_game() -> void:
	$Player.start($SpawnLocation.position)

func _on_player_death() -> void:
	$HUD.show_game_over()

func _on_player_victory() -> void:
	$HUD.show_win()

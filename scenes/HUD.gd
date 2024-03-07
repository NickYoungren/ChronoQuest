extends CanvasLayer

signal start_game
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_message(text):
	$message.text = text
	$message.show()
	$messageTimer.start()
	
func show_game_over():
	show_message("you've died")
	await $messageTimer.timeout
	$message.text = "try again"
	$message.show()
	await get_tree().create_timer(1.0).timeout
	$startButton.show()
	
func show_win():
	show_message("you win")
	
func _on_start_button_pressed() -> void:
	$startButton.hide()
	$message.hide()
	start_game.emit()

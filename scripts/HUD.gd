extends CanvasLayer

var message_label: Label # Declare message_label variable

var textureArray = []

#func _on_player_death():
	#message_label = get_node("message_label")
	#message_label.text = "You died!"
	#message_label.show()
func _ready(): 
	textureArray.append(load("res://Assets/chargebar/chargebar_47.png"))
	textureArray.append(load("res://Assets/chargebar/chargebar_46.png"))
	textureArray.append(load("res://Assets/chargebar/chargebar_45.png"))
	textureArray.append(load("res://Assets/chargebar/chargebar_44.png"))
	textureArray.append(load("res://Assets/chargebar/chargebar_43.png"))
	textureArray.append(load("res://Assets/chargebar/chargebar_42.png"))
	
func _process(float):
	if (Game.charges >= 0):
		#will never be higher than 47 or lower than 42
		var charges = clamp(Game.charges, 0, 5)
		#$ChargeBar.texture = textureArray[charges]
		
func _on_player_victory():
	message_label = get_node("message_label")
	message_label.text = "You won!"
	message_label.show()

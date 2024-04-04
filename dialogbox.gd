extends CanvasLayer

@export_file("*.json") var scene_text_file

var scene_text = {}
var selected_text = []
var selected_text_copy = []
var in_progress = false

var typing_speed = .1
var read_time = 2

var current_message = 0
var display = ""
var current_char = 0

	
@onready var background = $background
@onready var text_label = $Label

func _ready():
	background.visible = false
	scene_text = load_scene_text()
	Signalbus.connect("display_dialog", on_display_dialog)
	
func load_scene_text():
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	var data = file.get_as_text()
	return JSON.parse_string(data)
		

func on_display_dialog(text_key):
	if not in_progress:
		scene_text = load_scene_text()
		background.visible = true
		in_progress = true
		selected_text = scene_text[text_key]
		selected_text_copy = scene_text[text_key]
		start_dialogue()
		
func start_dialogue():
	current_message = 0
	display = ""
	current_char = 0
	
	$next_char.set_wait_time(typing_speed)
	$next_char.start()

func stop_dialogue():
	# get_parent().remove_child(self)
	in_progress = false
	queue_free()

func _on_next_char_timeout():
	if (current_char < len(selected_text[current_message])):
		var next_char = selected_text[current_message][current_char]
		display += next_char
		
		$Label.text = display
		current_char += 1
	else:
		$next_char.stop()
		$next_message.one_shot = true
		$next_message.set_wait_time(read_time)
		$next_message.start()

func _on_next_message_timeout():
	if (current_message == len(selected_text) - 1):
		stop_dialogue()
	else: 
		current_message += 1
		display = ""
		current_char = 0
		$next_char.start()

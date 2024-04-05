extends Area2D

enum SaplingStates {
	bush, #The initial state
	palm,
	tree #After the item is interacted with
}

@onready var timer: Timer = $Timer
@onready var current_state = SaplingStates.bush
@onready var anim = get_node("AnimatedSprite2D")
@onready var anim2 = get_node("AnimatedSprite2D2")
@onready var anim3 = get_node("AnimatedSprite2D3")
@onready var arrow = get_node("AnimatedSprite2D4")
@onready var treecol = get_node("RigidBody2D/Tree")
@onready var treecol2 = get_node("RigidBody2D/Tree2")

@onready var grow = true

@onready var treepos = treecol.position
@onready var treepos2 = treecol2.position

func _ready():
	# Start in the idle state
	change_state(SaplingStates.bush)


func _input(event):
	if Input.is_action_just_pressed("ui_down") && grow:
		arrow.flip_h = false
		arrow.play("Forward")
		timer.start()
		if current_state == SaplingStates.palm:
			change_state(SaplingStates.tree)
		elif current_state == SaplingStates.tree:
			change_state(SaplingStates.bush)
	# Detect specific button press while the sapling is focused or interacted with
	if Input.is_action_just_pressed("ui_up")  && grow:
		arrow.flip_h = true
		arrow.play("Forward")
		timer.start()
		if current_state == SaplingStates.bush:
			change_state(SaplingStates.tree)
		elif current_state == SaplingStates.tree:
			change_state(SaplingStates.palm)

func change_state(new_state):
	current_state = new_state
	match current_state:
		SaplingStates.bush:
			anim.play("Bush")
			anim2.play("Null")
			anim3.play("Null")
			treecol.set_deferred("disabled", true)
			treecol2.set_deferred("disabled", true)
		SaplingStates.tree:
			anim.play("Null")
			anim2.play("Tree")
			anim3.play("Null")
			treecol.set_deferred("disabled", false)
			treecol2.set_deferred("disabled", true)
		SaplingStates.palm:
			anim.play("Null")
			anim2.play("Null")
			anim3.play("Tree2")
			treecol2.set_deferred("disabled", false)


func _on_body_entered(body):
	if body.name == "Player" :
		grow = false


func _on_body_exited(body):
	if body.name == "Player":
		grow = true


func _on_timer_timeout():
	arrow.play("Null")

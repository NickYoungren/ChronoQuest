extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var rewp = position
var b
var bul
var flipped = 1
var tween
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rew = false
var shooter=false
var message_label
@onready var anim = get_node("AnimationPlayer")
@onready var timer: Timer = $Timer
@export var orb : PackedScene
@export var bullet : PackedScene
var sready = true
signal death()
signal victory()


func _ready() -> void:
	message_label = get_node("/root/Level1/HUD/message_label")
	if message_label:
		message_label.hide() # Hide the label initially

	

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
func rewind():
	if rew == false:
		b = orb.instantiate()
		owner.add_child(b)
		b.position = position
		rewp = position
	else:
		anim.play("rewind")
		tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.set_loops().set_parallel(false)
		tween.tween_property(get_parent().get_node("Player"), "position", rewp, 0.5)
		owner.remove_child(b)
	rew = !rew;
	
func shoot():
	#add animation?
	#anim.play("Shoot")
	bul = bullet.instantiate()
	bul.setDir(flipped)
	owner.add_child(bul)
	if flipped == -1:
		bul.position = position + Vector2(-100, 0)
	else:
		bul.position = position


func _physics_process(delta):
	orb = load("res://scenes/orb.tscn")
	bullet = load("res://scenes/bullet.tscn")
	if position == rewp:
		if tween:
			tween.kill()
			anim.play("Idle")

	if Input.is_action_just_pressed('reset_level'):
		reset_level()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor()  && anim.current_animation != "rewind":
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("rewind"):
		rewind()
	if Input.is_action_just_pressed("shoot") && sready  && anim.current_animation != "rewind":
		if !direction && velocity.y == 0:
			get_node("AnimatedSprite2D").play("Shoot")
		#await get_node("AnimatedSprite2D").animation_finished
		shoot()
		timer.start()
		sready = false
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
		flipped = -1
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
		flipped = 1
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0  && anim.current_animation != "rewind":
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 && anim.current_animation != "rewind":
			anim.play("Idle")
	if velocity.y > 0  && anim.current_animation != "rewind":
		anim.play("Fall")
	move_and_slide()
	if Game.playerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://scenes/Game.tscn")
		
#currently the respawn button is Q
func handleRespawn():
	global_position = Vector2(166,379)
	
func reset_level():
	queue_free()
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_trap_body_entered(body):
	if body.name == "Player":
		#death.emit()
		Game.playerHP -= 3

func _on_win_body_entered(body):
	if body.name == "Player":
		victory.emit()
		get_tree().change_scene_to_file("res://scenes/level_complete.tscn")



func _on_timer_timeout():
	sready = true # Replace with function body.

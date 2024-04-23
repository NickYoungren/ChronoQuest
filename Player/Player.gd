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
@onready var bg_audio:= AudioStreamPlayer.new()
@onready var player_audio:= AudioStreamPlayer.new()
@export var orb : PackedScene
@export var bullet : PackedScene
var sready = true
signal death()
signal victory()

func _ready() -> void:
	Game.charges = 2
	message_label = get_node("/root/Level1/HUD/message_label")
	if message_label:
		message_label.hide() # Hide the label initially
	bg_audio.stream = load("res://Assets/2- Mental Vortex.mp3")
	bg_audio.autoplay = true
	add_child(bg_audio)
	add_child(player_audio)

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
		tween.tween_property(get_parent().get_node("Player"), "position", rewp, 0.2)
		owner.remove_child(b)
	rew = !rew;

func dash(direction):
	#NOTES IN DASH
	#Doesn't handle dashing up and down
	#Collides on the enemies because of collision masking
	if (Game.charges == 0):
		pass
	else:
		
		Game.charges -= 1
		anim.play("rewind")
		tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.set_loops().set_parallel(false)
		rewp = Vector2(position.x + (direction * 100), position.y)
		print(rewp)
		tween.tween_property(get_parent().get_node("Player"), "position", rewp, 0.1)

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
	
	if Input.is_action_just_pressed('reset_level'):
		reset_level()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor()  && anim.current_animation != "rewind":
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		$effects/runningFx.emitting = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("rewind"):
		rewind()
	if Input.is_action_just_pressed('dash'):
		dash(direction)
	if Input.is_action_just_pressed("shoot") && sready  && anim.current_animation != "rewind":
		if !direction && velocity.y == 0:
			get_node("AnimatedSprite2D").play("Shoot")
		#await get_node("AnimatedSprite2D").animation_finished
		shoot()
		$PlayerFx.stream = load("res://Assets/ELECSprk_Anime Spark 1.wav")
		$PlayerFx.play()
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
			$effects/runningFx.emitting = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 && anim.current_animation != "rewind":
			anim.play("Idle")
			$effects/runningFx.emitting = false
	if velocity.y > 0  && anim.current_animation != "rewind":
		anim.play("Fall")
	move_and_slide()
	if Game.playerHP <= 0:
		queue_free()
		ChangeScene.change_scene("res://scenes/Game.tscn")

#currently the respawn button is Q
func handleRespawn():
	global_position = Vector2(166,379)
	
func reset_level():
	queue_free()
	if Game.level == 1:
		ChangeScene.change_scene("res://scenes/world.tscn")
	elif Game.level == 2:
		ChangeScene.change_scene("res://scenes/room.tscn")
	elif Game.level >= 3:
		ChangeScene.change_scene("res://scenes/2floor.tscn")

func _on_trap_body_entered(body):
	if body.name == "Player":
		death.emit()
		anim.play("Hurt")
		$AnimatedSprite2D.visible = false
		$effects/explodeFx.emitting = true
		#this wait is scuffed but whatever
		await get_tree().create_timer(1).timeout
		ChangeScene.change_scene("res://scenes/death_scene.tscn")

func _on_win_body_entered(body):
	if body.name == "Player":
		victory.emit()
		Game.level += 1
		print(Game.level)
		ChangeScene.change_scene("res://scenes/level_complete.tscn")

func _on_timer_timeout():
	sready = true # Replace with function body.

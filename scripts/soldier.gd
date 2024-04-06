extends CharacterBody2D

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var stunned = false
@onready var timer: Timer = $Timer

func _ready():
	get_node("AnimatedSprite2D").play("Walk")
func _physics_process(delta):
	#Gravity for Frog
	velocity.y += gravity * delta
	if chase == true && !stunned:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Walk")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death" && !stunned:
			get_node("AnimatedSprite2D").play("Idle")
		velocity.x = 0	
	move_and_slide()
func _on_player_detection_body_entered(body):
	if body.name == "Player" && !stunned:
		chase = true
		

func death():
	Game.Gold += 5
	Game.charges +=1
	Utils.saveGame()
	chase = false
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		Game.playerHP -= 3;
		death()


func stun():
	get_node("AnimatedSprite2D").play("stunned")
	stunned = true
	timer.start()

func _on_timer_timeout():
	stunned = false

extends CharacterBody2D


const SPEED = 40.0
const JUMP_VELOCITY = -400.0

var direction = Vector2(-1, 0)
var bounce_counter = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.y = - 300
	velocity.x = SPEED * direction.x

func bounce():
	if bounce_counter > 0:
		velocity.y = -200 / 2 * bounce_counter
		bounce_counter -= 1
	else:
		velocity  = Vector2(0, 0)
		
	

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		rotate(10 * delta)
	else:
		bounce()
	move_and_slide()

func explode():
	spawn_explosion()
	queue_free()

func spawn_explosion():
	var explosion = preload("res://Common/Explosion/enemy_explosion.tscn").instantiate()
	explosion.position = position
	get_parent().add_child(explosion)
	


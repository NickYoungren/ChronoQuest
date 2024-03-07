extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	velocity.y = -300
	scale.x = -1


func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	velocity.x += SPEED * delta

	move_and_slide()


func spawn_water_splash():
	var water_splash = preload("res://Common/WaterSplash/water_splash.tscn").instantiate()
	water_splash.position = position + Vector2(-4, -20)
	water_splash.z_index = 2
	get_parent().call_deferred("add_child", water_splash)

func _on_visible_on_screen_notifier_2d_screen_exited():
	spawn_water_splash()
	queue_free()


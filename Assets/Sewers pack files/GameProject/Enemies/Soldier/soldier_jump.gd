extends CharacterBody2D

@onready var collision = $CollisionShape2D
@onready var sprite = $SpriteHolder/Sprite2D
@onready var trigger_area := $TriggerArea

const JUMP_VELOCITY = -500.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_physics_process(false)


func _physics_process(delta):

	if velocity.y > 20:
		collision.disabled = false
		z_index = 2

	# Add the gravity.
	if is_on_floor():
		spawn_soldier()
		queue_free()
	
	velocity.y += gravity * delta
	move_and_slide()

func spawn_soldier():
	var soldier = preload("res://Enemies/Soldier/soldier.tscn").instantiate()
	soldier.position = position 
	soldier.soldier_action = randi() % 4 # select a random action for the soldier beteween 0 and 3
	get_parent().add_child(soldier)
	
	# # get node in the player group
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		var player = players[0]
		# set the direction of the soldier
		if player.global_position > global_position:
			soldier.direction = 1
		else:
			soldier.direction = -1

func spawn_water_splash():
	var water_splash = preload("res://Common/WaterSplash/water_splash.tscn").instantiate()
	water_splash.position = position + Vector2(-4, -90)
	water_splash.z_index = -1
	get_parent().call_deferred("add_child", water_splash)	
	

func _on_trigger_area_area_entered(area):
	spawn_water_splash()
	velocity.y = JUMP_VELOCITY
	set_physics_process(true)
	trigger_area.queue_free()


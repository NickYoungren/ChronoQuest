extends CharacterBody2D
@onready var sprite = $SpriteHolder/AnimatedSprite2D
@onready var sprite_holder = $SpriteHolder
@onready var muzzle_flash = $SpriteHolder/MuzzleFlash
@onready var muzzle_flash_crouch = $SpriteHolder/MuzzleFlashCrouch
@onready var chillout_timer = $ChilloutTimer
@onready var hurt_area = $HurtArea


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 600.0
const FRICTION  = 1000.0

var standing_shooting_flag := false
var crouching_flag := false
var can_shoot_flag := true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	

	if global_position.y > 300:
		fall()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

		
	# Crouch
	if Input.is_action_pressed("crouch") and is_on_floor():
		sprite.play("crouch")
		standing_shooting_flag = false
		crouching_flag = true
		handle_shoot()
		hurt_area.scale.y = 0.7
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		move_and_slide()
		return
	
	hurt_area.scale.y = 1.0
	# Shoot
	crouching_flag = false
	handle_shoot()

	handle_jump()
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
	manage_animations(direction)

	# limit global position
	if global_position.x < 0:
		global_position.x = 0
	elif global_position.x > 360:
		global_position.x = 360
		


func handle_shoot()->void:
	if Input.is_action_pressed("shoot"):
		standing_shooting_flag = true
		if not can_shoot_flag:
			return
		if not crouching_flag:
			muzzle_flash.play("default")
		else:
			muzzle_flash_crouch.play("default")
		spawn_bullet()
		can_shoot_flag = false
		chillout_timer.start()
	

func spawn_bullet()->void:
	var bullet = preload("res://Projectiles/PlayerBullet/PlayerBullet.tscn").instantiate()
	bullet.direction.x = sprite_holder.scale.x
	if sprite.animation == "crouch":
		bullet.global_position = muzzle_flash_crouch.global_position
	else:
		bullet.global_position = muzzle_flash.global_position
	get_tree().current_scene.call_deferred("add_child", bullet)
	
	
func handle_jump()->void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
func manage_animations(direction)->void:
	
	
	if not is_on_floor():
		standing_shooting_flag = false
		if velocity.y > 0:
			# if animation already playing, don't play it again
			if sprite.animation != "fall":

				sprite.play("fall")
		else:
			sprite.play("jump")
	else:
		if direction != 0:
			sprite_holder.scale.x = direction
			sprite.play("run")
			standing_shooting_flag = false
		else:
			if standing_shooting_flag:
				sprite.play("shoot")
			else:
				sprite.play("idle")
	

func _on_chillout_timer_timeout()->void:
	can_shoot_flag = true
	standing_shooting_flag = false


func kill()->void:
	var death = preload("res://Player/PlayerDeath/player_death.tscn").instantiate()
	death.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", death)
	queue_free()

func fall()->void:
	spawn_water_splash()
	var death = preload("res://Player/PlayerDeath/player_death.tscn").instantiate()
	death.global_position = global_position + Vector2(0, 0)
	get_tree().current_scene.call_deferred("add_child", death)
	queue_free()

func spawn_water_splash():
	var water_splash = preload("res://Common/WaterSplash/water_splash.tscn").instantiate()
	water_splash.position = position + Vector2(-4, -120)
	water_splash.z_index = 2
	get_parent().call_deferred("add_child", water_splash)
	


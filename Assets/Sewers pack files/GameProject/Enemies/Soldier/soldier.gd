extends CharacterBody2D

@onready var sprite = $SpriteHolder/Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var muzzle_flash = $SpriteHolder/MuzzleFlash
@onready var muzzle_flash_crouch = $SpriteHolder/MuzzleFlashCrouch
@onready var sprite_holder = $SpriteHolder
@onready var hurt_area = $HurtArea





# export an enum to be used in the editor
enum Action { SHOOTING_STAND, SHOOTING_CROUCH, RUNNING, THROWING}
@export var soldier_action : Action = Action.SHOOTING_STAND



const SPEED = 100.0
const JUMP_VELOCITY = -200.0
var direction = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	# random integer number between 0 and 3
	var random_integer = randi() % 4

	print(random_integer)

	set_action()


func set_action():
	if soldier_action == Action.THROWING:
		animation_player.play("throw")
		hurt_area.scale.y = 0.5
	else:
		if soldier_action == Action.SHOOTING_CROUCH:
			animation_player.play("crouching_shoot")
			hurt_area.scale.y = 0.5
		elif soldier_action == Action.SHOOTING_STAND:
			animation_player.play("standing_shoot")
			hurt_area.scale.y = 1.0

func _physics_process(delta):
	sprite_holder.scale.x = direction

	if soldier_action == Action.RUNNING:
		velocity.x = SPEED * direction
		animation_player.play("run")
		hurt_area.scale.y = 1.0
	else:
		velocity.x = 0

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func handle_shoot():
	spawn_bullet(false)
	muzzle_flash.play("default")

func handle_shoot_crouch():
	spawn_bullet(true)
	muzzle_flash_crouch.play("default")
	
func handle_throw():
	var grenade = preload("res://Projectiles/EnemyBomb/enemy_bomb.tscn").instantiate()
	grenade.direction.x = sprite_holder.scale.x
	grenade.position = position + muzzle_flash_crouch.position * grenade.direction.x # calculate the position of the grenade
	get_parent().add_child(grenade)
	

func spawn_bullet(crouch: bool)->void:
	var bullet = preload("res://Projectiles/EnemyBullet/EnemyBullet.tscn").instantiate()
	bullet.direction.x = sprite_holder.scale.x
	if crouch:
		bullet.global_position = muzzle_flash_crouch.global_position
	else:
		bullet.global_position = muzzle_flash.global_position
	get_tree().current_scene.call_deferred("add_child", bullet)

func kill():
	var death = preload("res://Enemies/Soldier/SoldierDeath/soldier_death.tscn").instantiate()
	death.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", death)
	queue_free()



func _on_hit_box_area_entered(area):
	area.owner.kill()

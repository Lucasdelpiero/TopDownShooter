extends KinematicBody2D

const Blood = preload("res://Characters/zombi/blood.tscn")
const bullet = preload("res://Characters/Player/Top_Down_Survivor/bullet.png")

onready var animatedSprite = $AnimatedSprite
onready var wanderController = $WanderController
onready var audioStreamPlayer = $AudioStreamPlayer
onready var zombiSoundTimer = $ZombiSoundTimer
onready var position2d = $Position2D
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var arrow = $Direction

enum{
	IDLE,
	WANDER,
	CHASE
}
export var ACCELERATION = 300
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 8
var state = IDLE
var velocity = Vector2.ZERO
export var max_speed = 200
var acceleration = 40
var direction = 0.0
export var health = 5
var player = null

func _ready():
	animatedSprite.rotation_degrees = rand_range(-180, 180)
	animatedSprite.frame = rand_range(0, 8)
	animatedSprite.playing = true
	zombiSoundTimer.start(rand_range(4,40))

func _physics_process(delta):
	match state:
		IDLE:
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				update_wander()
			idle_state(delta)
		
		WANDER:
			seek_player()
			wander_state(delta)
		CHASE:
#			chase_state(delta)
			var player = playerDetectionZone.player
			if player != null:
				direction = get_angle_to(player.get_global_position())
				velocity = Vector2(cos(direction) * max_speed, sin(direction) * max_speed)
			else:
				state = IDLE
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	animatedSprite.rotation_degrees = rad2deg(direction)

#STATE MACHINE
func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if wanderController.get_time_left() == 0:
		update_wander()

func wander_state(delta):
	if wanderController.get_time_left() == 0:
		update_wander()
	direction = get_angle_to(wanderController.target_position)
	velocity = Vector2(cos(direction) * max_speed, sin(direction) * max_speed)

func update_wander():
	state = pick_random_state([IDLE, WANDER]) # si se ponen los [ ] se convierte en array
	wanderController.start_wander_timer(rand_range(1, 3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
#func chase_state(delta):
#	var player = playerDetectionZone.player
#	if player != null:
#		accelerate_towards_point(player.global_position, delta)
##		velocity.x = move_toward(global_position.x , player.global_position.x ,50* delta)
#	else:
#		state = IDLE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Area_body_entered(body):
	health -= 1
	body.queue_free()
	body.velocity *= 0.75
	
	if health < 1:
		death()

func _on_ZombiSound_timeout():
	audioStreamPlayer.playing = true

#func _on_Area_area_entered(area):
#	death()

func _on_HurtBox_area_entered(area):
	health -= area.damage
	if health < 1:
		death()

func death():
	queue_free()
	var blood = Blood.instance()
	get_parent().add_child(blood)
	blood.global_position = global_position 

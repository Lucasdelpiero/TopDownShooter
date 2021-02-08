extends KinematicBody2D

const Blood = preload("res://Characters/zombi/blood.tscn")
const bullet = preload("res://Characters/Player/Top_Down_Survivor/bullet.png")
const Explosion = preload("res://World/Objects/Barrel/Explosion.tscn")
const BloodParticle = preload("res://Characters/zombi/Blood/BloodParticles.tscn")
const BloodStain = preload("res://Characters/zombi/Blood/BloodStain.tscn")



onready var animatedSprite = $AnimatedSprite
onready var wanderController = $WanderController
onready var audioStreamPlayer = $AudioStreamPlayer
onready var audioHitted = $AudioHitted
onready var zombiSoundTimer = $ZombiSoundTimer
onready var position2d = $Position2D
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var navigation = get_tree().get_root().find_node("Navigation2D", true, false)
onready var rayCast = $RayCast2D
onready var pathTimer = $PathFindTimer

signal killed(type, byMelee, byExplosion)
signal fillPlayerAmmo()
var type = null


const soundsHitted = [
	"bullet_hit_body_0",
	"bullet_hit_body_1",
	"bullet_hit_body_2",
	"bullet_hit_body_3",
]

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
export var explosive = false
export var rotationSmooth = 0.125
var usePathfinding = false
var timeToPathfind : float = 1.0

export var path : = PoolVector2Array() setget set_path

func _ready():
	set_process(false)
	wallCollide(true)
	randomize()
	timeToPathfind += randf()
	animatedSprite.rotation_degrees = rand_range(-180, 180)
	animatedSprite.frame = rand_range(0, 8)
	animatedSprite.playing = true
	zombiSoundTimer.start(rand_range(4,40))
	yield(get_tree().get_root(), "ready")
	var scoreControl = get_tree().get_root().find_node("Scoring", true, false)
	connect("killed", scoreControl, "updateScore")
	get_type()


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
			wander_state()
			animatedSprite.rotation_degrees = rad2deg(direction)
	if player != null:
		var angle = get_angle_to(player.position)
		rayCast.set_cast_to( position.distance_to(player.position) * position.direction_to(player.position) )
	
func _process(delta):
	match state:
		CHASE:
			chase_state(delta)
			animatedSprite.rotation = lerp_angle(animatedSprite.rotation, direction, rotationSmooth)

	
#STATE MACHINE
func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if wanderController.get_time_left() == 0:
		update_wander()

func wander_state():
	if wanderController.get_time_left() == 0:
		wanderController.start_position = global_position
		update_wander()
	direction = get_angle_to(wanderController.target_position)
	velocity = Vector2(cos(direction) * max_speed, sin(direction) * max_speed)
	velocity = move_and_slide(velocity)
	if global_position.distance_to(wanderController.target_position) < max_speed or get_slide_count() > 0 :
		state = IDLE

func update_wander():
	state = pick_random_state([IDLE, WANDER]) # si se ponen los [ ] se convierte en array
	wanderController.start_wander_timer(rand_range(1, 3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		wallCollide(false)


func chase_state(delta):
	player = playerDetectionZone.player
	if player == null:
		state = IDLE
		wallCollide(true)
		
	else:
		if rayCast.is_colliding():
#		if usePathfinding:
			if pathTimer.is_stopped():
				get_path()
			var moveDistance = max_speed * delta
			move_along_path(moveDistance)
		else:
			moveDirect()

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_ZombiSound_timeout():
	audioStreamPlayer.playing = true

func _on_HurtBox_area_entered(area):
	var bloodParticle = BloodParticle.instance()
	get_parent().add_child(bloodParticle)
	bloodParticle.global_position = global_position
	if area.get_parent().is_in_group("Bullets"):
		bloodParticle.rotation = area.get_parent().direction + 3.14
		soundHitted()
	else:
		bloodParticle.rotation = direction
	
	if health > 0:
		health -= area.damage
		if health < 1:
			if area.get_parent().is_in_group("Knife"):
				connect("fillPlayerAmmo", get_tree().get_nodes_in_group("Player")[0], "fillAmmo" )
				emit_signal("fillPlayerAmmo")
			death(area)

func death(area):
	queue_free()
	
	var blood = Blood.instance()
	get_parent().add_child(blood)
	blood.global_position = global_position 
	
	var bloodStain = BloodStain.instance()
	get_parent().add_child(bloodStain)
	bloodStain.global_position = global_position
	bloodStain.rotation = rand_range(0, 2)
	
	if explosive:
		var explosion = Explosion.instance()
		get_parent().add_child(explosion)
		explosion.global_position = global_position
	
	var byMelee = area.get_parent().is_in_group("Melee")
	var byExplosion = area.get_parent().is_in_group("Explosion")
	
	emit_signal("killed", str(type), byMelee, byExplosion)

func get_type():
	var groups = self.get_groups()
	if str(groups[0]) != "physics_process":
		type = groups[0]
	else:
		type = groups[1]

func soundHitted():
	audioHitted.stream = load( "res://Characters/zombi/Audio/%s.wav" %str(soundsHitted[randi() % soundsHitted.size()]) ) 
	audioHitted.play()

# Path Finding
func move_along_path(distance : float) -> void:
	var startPoint = position
	for i in range(path.size()):
		var distanceToNextPoint = startPoint.distance_to(path[0])
		if distance <= distanceToNextPoint  and distance >= 0.0:
#			position = startPoint.linear_interpolate(path[0], distance / distanceToNextPoint)
			direction = get_angle_to(path[0])
			velocity = Vector2(cos(direction) * max_speed, sin(direction) * max_speed)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		distance -= distanceToNextPoint
		startPoint = path[0]
		path.remove(0)
#	move_and_slide( Vector2(0.0, 0.0) )
	velocity = move_and_slide(velocity)


func set_path(value : PoolVector2Array) -> void :
	path = value
	if value.size() == 0 :
		return
	set_process(true)

func get_path():
	if player != null:
		if rayCast.is_colliding():
			usePathfinding = true
			path = navigation.get_simple_path(global_position, player.global_position, true)
			pathTimer.start(timeToPathfind) #0.2 originally
		else:
			usePathfinding = false
			

func moveDirect():
		direction = get_angle_to(player.get_global_position())
		velocity = Vector2(cos(direction) * max_speed, sin(direction) * max_speed)
		velocity = move_and_slide(velocity)

func _on_PathFindTimer_timeout():
	get_path()

func wallCollide(value : bool):
	set_collision_mask_bit(2, value)

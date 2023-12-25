extends KinematicBody2D

const Blood = preload("res://Characters/zombi/blood.tscn")
const bullet = preload("res://Characters/Player/Top_Down_Survivor/bullet.png")
const Explosion = preload("res://World/Objects/Barrel/Explosion.tscn")
const BloodParticle = preload("res://Characters/zombi/Blood/BloodParticles.tscn")
const BloodStain = preload("res://Characters/zombi/Blood/BloodStain.tscn")
const Corpse = preload("res://Characters/zombi/Animations/ZombiCorpse.tscn")
const ScoreBubble = preload("res://Effects/ScoreBubble.tscn")

onready var wanderController = get_node(path_wanderController)
export var path_wanderController : NodePath
onready var audioStreamPlayer : AudioStreamPlayer = get_node(path_audioStreamPlayer)
export var path_audioStreamPlayer : NodePath
onready var audioHitted : AudioStreamPlayer = get_node(path_audioHitted)
export var path_audioHitted : NodePath
onready var zombiSoundTimer : Timer = get_node(path_zombiSoundTimer)
export var path_zombiSoundTimer : NodePath
onready var position2d : Position2D = get_node(path_position2d)
export var path_position2d : NodePath
onready var playerDetectionZone = get_node(path_playerDetectionZone)
export var path_playerDetectionZone : NodePath
export var path_hitbox : NodePath
onready var hitbox = get_node(path_hitbox)
onready var softCollision = get_node(path_softCollision)
export var path_softCollision : NodePath
onready var navigation = get_tree().get_root().find_node("Navigation2D", true, false)
onready var rayCast = get_node(path_rayCast)
export var path_rayCast : NodePath
onready var pathTimer = get_node(path_Timer)
export var path_Timer : NodePath
onready var animationPlayer = get_node(path_animationPlayer)
export var path_animationPlayer : NodePath
onready var sprite = get_node(path_sprite)
export var path_sprite : NodePath
onready var pivotSprites = get_node(path_pivotSprites)
export var path_pivotSprites : NodePath
onready var bleedTimer = get_node(path_bleedTimer)
export var path_bleedTimer : NodePath
onready var staggerTimer = get_node(path_staggerTimer)
export var path_staggerTimer : NodePath
onready var collision = get_node(path_collision)
export var path_collision : NodePath 
onready var visibilityEnabler  = get_node(path_visibilityEnabler)
export var path_visibilityEnabler : NodePath
export var path_navAgent : NodePath
onready var navAgent : NavigationAgent2D = get_node(path_navAgent)

signal killed(type, byMelee, byExplosion, pos)
signal fillPlayerAmmo()
signal healPlayer(time)

#const soundsHitted = [
#	"bullet_hit_body_0",
#	"bullet_hit_body_1",
#	"bullet_hit_body_2",
#	"bullet_hit_body_3",
#]

const soundsHitted = [
	preload("res://Characters/zombi/Audio/bullet_hit_body_0.wav"),
	preload("res://Characters/zombi/Audio/bullet_hit_body_1.wav"),
	preload("res://Characters/zombi/Audio/bullet_hit_body_2.ogg"),
	preload("res://Characters/zombi/Audio/bullet_hit_body_2.wav"),
	preload("res://Characters/zombi/Audio/bullet_hit_body_3.wav"),
	preload("res://Characters/zombi/Audio/bullet_hit_body_4.wav"),
]

enum{
	IDLE,
	WANDER,
	CHASE,
	STAGGERED,
}
var GRID_SIZE = 128
var DISTANCE_TO_REPATH = 800
export var MAX_SPEED = 200
export var ACCELERATION = 300
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 8
var state = IDLE
var velocity = Vector2.ZERO
var direction = 0.0
export var health = 5
var player = null
export var explosive = false
export var rotationSmooth = 0.125
var usePathfinding = false
var timeToPathfind : float = 1.0
export(String, "zombi", "zombiFat", "zombiFast", "zombiExplosive") var type = "zombi"
var attacking = false
var staggered = false
var bleeding = false
var frenzy = false # will chase player even outside sight

export var customDamage = false
export var damage = 10

export var path : = PoolVector2Array() setget set_path

func _on_zombi_tree_entered():
	z_index = GlobalControl.Z_INDEX["ZOMBI"]
	set_process(false)
	wallCollide(true) 
	randomize()
	yield(get_tree().create_timer(0.01), "timeout")
	var scoreControl = get_tree().get_root().find_node("Scoring", true, false)
	var objectiveControl = get_tree().get_root().find_node("Objectives", true, false)
# warning-ignore:return_value_discarded
	connect("killed", scoreControl, "updateScore")
# warning-ignore:return_value_discarded
	connect("killed", objectiveControl, "updateObjective")

func _ready():
	timeToPathfind += randf()
	if sprite != null:
		sprite.rotation_degrees = rand_range(-180, 180)
		if sprite.vframes > 1 or sprite.hframes > 1:
			sprite.frame = rand_range(0, 8)
	else: push_error("There is not sprite reference")
	
	if zombiSoundTimer != null:
		zombiSoundTimer.start(rand_range(4,40))
	else: push_error("There is not zombiSoundTimer reference")
	
	if customDamage:
		if hitbox != null:
			hitbox.damage = damage
		else: push_error("There is not hitbox reference")

func _physics_process(delta):

	match state:
		IDLE:
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController!= null:
				if wanderController.get_time_left() == 0:
					update_wander()
			else: push_error("There is not wander controller reference")
#			idle_state(delta)
			if animationPlayer != null:
				animationPlayer.play("Idle")
			else: push_error("There is not animation player reference")
			
		WANDER:
			seek_player()
			wander_state()
			if sprite != null:
				sprite.rotation_degrees = rad2deg(direction)
			else: push_error("There is not sprite")
			if pivotSprites != null:
				pivotSprites.rotation = sprite.rotation
			else: push_error("There is not pivotSprites")
			if animationPlayer != null:
				animationPlayer.play("Move")
			else: push_error("There is not animationPlayer")

		STAGGERED:
			stagger()
			velocity = move_and_slide(velocity)
	if player != null:
#		var angle = get_angle_to(player.global_position)
		if rayCast != null:
			rayCast.set_cast_to( global_position.distance_to(player.global_position) * global_position.direction_to(player.global_position) )
		else: push_error("There is not raycas")
	
	if frenzy: # Test
		state = CHASE
	match state:
		CHASE:
			chase_state(delta)
			if sprite != null:
				sprite.rotation = lerp_angle(sprite.rotation, direction, rotationSmooth)
			if pivotSprites != null:
				pivotSprites.rotation = sprite.rotation
			if attacking == false:
				if animationPlayer != null:
					animationPlayer.play("Move")
				else : push_error("There is not animation player")
	
#func _process(delta):
#	if frenzy:
#		state = CHASE
#	match state:
#		CHASE:
#			chase_state(delta)
#			if sprite != null:
#				sprite.rotation = lerp_angle(sprite.rotation, direction, rotationSmooth)
#			if pivotSprites != null:
#				pivotSprites.rotation = sprite.rotation
#			if attacking == false:
#				if animationPlayer != null:
#					animationPlayer.play("Move")
#				else : push_error("There is not animation player")
	
#STATE MACHINE
func idle_state(delta):
	wallCollide(true)
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if wanderController == null:
		push_error("There is not wander controlller")
		return
	if wanderController.get_time_left() == 0:
		update_wander()

func wander_state():
	wallCollide(true)
	if wanderController == null:
		push_error("There is not wander controller")
		return
	if wanderController.get_time_left() == 0:
		wanderController.start_position = global_position
		update_wander()
	direction = get_angle_to(wanderController.target_position)
	velocity = Vector2(cos(direction) * MAX_SPEED, sin(direction) * MAX_SPEED)

	velocity = move_and_slide(velocity)
	if global_position.distance_to(wanderController.target_position) < MAX_SPEED or get_slide_count() > 0 :
		state = IDLE
	

func update_wander():
	if wanderController == null:
		return
	state = pick_random_state([IDLE, WANDER]) # si se ponen los [ ] se convierte en array
	wanderController.start_wander_timer(rand_range(1, 3))

func seek_player():
	if playerDetectionZone == null:
		push_error("There is not player detection zone")
		return
	player = playerDetectionZone.player
	if playerDetectionZone.can_see_player():
		if not rayCast.is_colliding():
			state = CHASE
#			wallCollide(false) ## activated so they dont stuck in walls

var transitionToPath = false # If goes from going in a line to using a pathfinding
func chase_state(delta):
	if playerDetectionZone == null:
		push_error("There is not player detection zone")
		return
	player = playerDetectionZone.player
	wallCollide(false)
#	collision.disabled = true # used so that the zombies dont get stuck in the walls
	if player == null and !frenzy:
		state = IDLE
		wallCollide(false) 
	else:
		if rayCast == null:
			push_error("There is not raycast")
			return
		if rayCast.is_colliding():
#		if usePathfinding:
			if pathTimer.is_stopped():
				get_path()
			var moveDistance = MAX_SPEED * delta
			move_along_path(moveDistance)
			
			if navAgent == null:
				push_error("There is not navAgent")
				return
			

		
		else:
			moveDirect()
#			transitionToPath = false

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func unfreeze(): # If they spawn outside the screen they will not freeze
	visibilityEnabler = get_node(path_visibilityEnabler)
	if visibilityEnabler == null:
		push_error("There is not visibility enabler")
		return
	visibilityEnabler.process_parent = false
	visibilityEnabler.physics_process_parent = false

func _on_ZombiSound_timeout():
	if audioStreamPlayer == null:
		push_error("There is not audioStreamPlayer")
		return
	audioStreamPlayer.playing = true

func _on_HurtBox_area_entered(area):
	bleed(area)
#	print("damaged")
	staggered = true
	state = STAGGERED
	
	if health > 0:
		health -= area.damage
		if health < 1:
			if area.get_parent().is_in_group("Knife"):
# warning-ignore:return_value_discarded
				connect("fillPlayerAmmo", get_tree().get_nodes_in_group("Weapons")[0], "fillAmmo" )
# warning-ignore:return_value_discarded
				connect("healPlayer", player, "bonusHeal")
				emit_signal("fillPlayerAmmo")
			death(area)

func bleed(area):
	if bleedTimer == null:
		push_error("There is not bleed timer")
		return
	if bleeding == false:
		bleeding = true
		bleedTimer.start()
		var bloodParticle = BloodParticle.instance()
		get_parent().add_child(bloodParticle)
		bloodParticle.global_position = global_position
		if area.get_parent().is_in_group("Bullets"):
			bloodParticle.rotation = area.get_parent().direction + 3.14
			soundHitted()
		else:
			bloodParticle.rotation = direction



func stagger():
	if staggerTimer == null:
		push_error("There is not stagger timer")
		return
	var staggerTime = 0.1
	velocity = lerp(velocity, velocity / 2 , staggerTime)
	if staggered:
		staggerTimer.start()
		staggered = false

func _on_StaggerTimer_timeout():
	state = IDLE

func death(area):
	queue_free()
	
	var blood = Blood.instance()
	get_parent().add_child(blood)
	blood.global_position = global_position 
	
	var bloodStain = BloodStain.instance()
	get_parent().add_child(bloodStain)
	bloodStain.global_position = global_position
	bloodStain.rotation = rand_range(0, 2)
	
#	var scoreBubble = ScoreBubble.instance()
#	get_parent().add_child(scoreBubble)
#	scoreBubble.global_position = global_position
#	scoreBubble.text = "50000"
	
	if explosive:
		var explosion = Explosion.instance()
#		get_parent().add_child(explosion)
		get_parent().call_deferred("add_child", explosion)
		explosion.global_position = global_position
	
	var byMelee = area.get_parent().is_in_group("Melee")
	var byExplosion = area.get_parent().is_in_group("Explosion")
	
	emit_signal("killed", str(type), byMelee, byExplosion, global_position)
	
	var corpse = Corpse.instance()
#	get_parent().add_child(corpse)
	get_parent().call_deferred("add_child", corpse)
	corpse.global_position = global_position
#	corpse.rotation = sprite.rotation
	corpse.rotation = get_angle_to(area.global_position)
	corpse.type = type
	if byMelee or byExplosion:
		corpse.push()

func soundHitted():
	if audioHitted == null:
		push_error("There is not audio hitted")
		return
#	audioHitted.stream = load( "res://Characters/zombi/Audio/%s.wav" %str(soundsHitted[randi() % soundsHitted.size()]) ) 
	audioHitted.stream = soundsHitted[randi() % soundsHitted.size()]
	audioHitted.play()

# Path Finding
func move_along_path(distance : float) -> void:
	var startPoint = position
	for _i in range(path.size()):
		var distanceToNextPoint = startPoint.distance_to(path[0])
		if distance <= distanceToNextPoint  and distance >= 0.0:
#			position = startPoint.linear_interpolate(path[0], distance / distanceToNextPoint)
			direction = get_angle_to(path[0])
			velocity = Vector2(cos(direction) * MAX_SPEED, sin(direction) * MAX_SPEED)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		distance -= distanceToNextPoint
		startPoint = path[0]
		path.remove(0)
#	move_and_slide( Vector2(0.0, 0.0) )
	if (velocity.x < 50 and velocity.y < 50):
#		print("trabado")
#		unStuck() # temporarely
		pass
	
	#test to see if it doest get stuck
#	move_and_slide(velocity, Vector2.UP, false, 16, PI, true)
	velocity = move_and_slide(velocity)  # MAYBE commenting this it wont get changed


func set_path(value : PoolVector2Array) -> void :
	path = value
	if value.size() == 0 :
		return
	set_process(true)

func get_path():
	if rayCast == null:
		push_error("There is not raycast")
		return
	if pathTimer == null:
		push_error("There is not path timer")
		return
	
	var playerPos = getPlayer()
	if rayCast.is_colliding():
		usePathfinding = true
#		path = navigation.get_simple_path(global_position, playerPos.global_position, true)
		path = navigation.get_simple_path(global_position, playerPos.global_position, false)
		
#		print(path.size())
#		path = navToCell(path)
#		$Node/Line2D.points = path
		pathTimer.start(timeToPathfind + rand_range(0.1, 0.5)) #0.2 originally
	else:
		usePathfinding = false

func nav_agent_get_path(player_pos):
	if navAgent == null:
		return []
#	if navAgent is NavigationAgent2D:
#		return []
	navAgent.set_target_location(player_pos)
	pass

func moveDirect():
	wallCollide(true) # what
	var playerPos = getPlayer()
	var playerDirection = get_angle_to(playerPos.get_global_position())
	direction = lerp_angle(direction, playerDirection, rotationSmooth)
	velocity.x = lerp(velocity.x, MAX_SPEED * cos(direction), 0.1)
	velocity.y = lerp(velocity.y, MAX_SPEED * sin(direction), 0.1)
	var push = softCollision.get_push_vector()
	velocity += push * MAX_SPEED / 64
	velocity = move_and_slide(velocity)

func _on_PathFindTimer_timeout():
#	if recalculatePath():
#		get_path()

	if playerDetectionZone == null: return
	var player = playerDetectionZone.player
	if player == null: 
		state = IDLE
		return
	
	navAgent.set_target_location(player.global_position)

func recalculatePath():
	if path.empty():
		return true
	var lastPoint = path[path.size() - 1]
#	print(path.size())
#	print(lastPoint)
	var playerPos = getPlayer()
	if playerPos == null:
		return false
	if playerPos.global_position.distance_to(lastPoint) > DISTANCE_TO_REPATH:
#		print("REPATH")
		return true
	return false

func wallCollide(value : bool):
#	set_collision_mask_bit(2, value)
	pass

func _on_Hitbox_body_entered(_body):
	if animationPlayer == null:
		push_error("There is not animation player")
		return
	attacking = true
	if type != "zombiBig":
		animationPlayer.play("Attack")

func notAttacking():
	if animationPlayer == null:
		push_error("There is not animation player")
		return
	attacking = false
	if type != "zombiBig":
		animationPlayer.play("Move")

func getPlayer(): # Only returns the player position if it is in the detection zone or if it is frenzy
	if frenzy:
		return get_tree().get_root().find_node("Player", true, false)
	if player != null:
		return player
	return get_tree().get_root().find_node("Player", true, false)

var unstucking = false
func unStuck():
	return # desactivated
	if !unstucking:
		unstucking = true
		collision.disabled = true
#		softCollision.set_collision_mask_bit(5, false)
#		yield(get_tree().create_timer(1.0), "timeout") #changed because it could crash
		$Timers/UnstuckTimer.start()
		collision.disabled = false
#		softCollision.set_collision_mask_bit(5, true)
		unstucking = false

# Makes the navigation paths go to the grids
func navToCell(ppath):
	var oldPath = ppath
	var newPath = []
	var offset = GRID_SIZE / 2 
	for el in path:
#		print("old: "+ str(el))
		var new = Vector2(int(el.x / GRID_SIZE) * GRID_SIZE , int(el.y / GRID_SIZE) * GRID_SIZE )
		newPath.push_back(new)
#		print("new " + str(new) )
		pass
#	print(path)
#	print(newPath)
	return newPath



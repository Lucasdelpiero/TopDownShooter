extends KinematicBody2D

var Bullet = preload("res://World/Objects/Bullet.tscn")
var Muzzle = preload("res://World/Objects/Muzzle.tscn")
var PlayerCamera = preload("res://World/Camera.tscn")


export var speed = 1600 #1200
export var acceleration = 9000 #2500
export(float, 0.01, 0.5) var idle_time = 0.1
var canShoot = true
var automatic = false
var velocity = Vector2.ZERO
export var health = 100 setget updateHealth, getHealth
var bonusHealing = false
var distanceToBendBullet = 400

var minBulletSpdBonus = 0.3
var maxBulletSpdBonus = 1000

signal updateHealthHUD(health)
signal grabAmmoSignal(amount)
signal player_death()

onready var animationPlayer = $Position2D/AnimationPlayer
onready var position2D = $Position2D
onready var hurtbox = $HurtBox
onready var timer = $IdleTimer
onready var audioGuns = $AudioGuns
onready var audioPain = $AudioPain
onready var healingTimer = $HealingTimer
onready var remoteTransform = $RemoteTransform2D
onready var spawnWeapons = $Position2D/SpawnWeapons

onready var weapons = $Position2D/Weapons
onready var knife = $Position2D/Knife
onready var knifeCollision = $Position2D/Knife/Hitbox/CollisionShape2D
onready var rayCastWall = $Position2D/RayCastWall

enum {
	IDLE,
	SHOOTING,
	RELOADING,
	MELEE,
	BLOCKED,
	DEAD
}

var state = IDLE

const painSounds = [
	"pain1",
	"pain2",
	"pain3",
]

const deathSounds = [
	"death1",
	"death2",
	"death3",
]

var animMove = "RifleMove"
var animIdle = "RifleIdle"
var animShoot = "RifleShoot"
var animReload = "RifleReload"
var animBlocked =  "RifleBlocked"
var animMelee = "KnifeMelee"

func _on_Player_tree_entered():
	yield(get_tree().create_timer(0.01), "timeout")
	var HUD = get_tree().get_root().find_node("HUD", true, false)
# warning-ignore:return_value_discarded
	if HUD != null:
		connect("updateHealthHUD", HUD, "_on_Player_updateHealth")
		connect("player_death", HUD, "on_player_death")
	randomize()
	get_tree().call_group("zombies", "set_player", self)
	knifeCollision.disabled = true

func _ready():
	yield(get_tree().create_timer(0.01), "timeout")
	var playerCamera = PlayerCamera.instance()
	get_parent().add_child(playerCamera)
	playerCamera.global_position = global_position
	remoteTransform.remote_path = "../../Camera"

var dir = 14

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state == DEAD:
		return
	
	$Position2D.look_at(get_global_mouse_position())
	move(delta)
	
	if Input.is_action_just_pressed("dash"):
		dash()
	
	match state:
		IDLE:
			rayCastWallCollision()
			
			if Input.is_action_pressed("shoot"):
				weapons.trigger()

	
			
			if Input.is_action_just_pressed("knife"):
				melee()
				state = MELEE
			
			if Input.is_action_just_pressed("reload"):
				weapons.startReloading()

		
		RELOADING:
			if Input.is_action_just_pressed("knife"):
				melee()
				state = MELEE
		
		BLOCKED:
			rayCastWallCollision()
			if Input.is_action_just_pressed("knife"):
				melee()
				state = MELEE
func move(delta):
	dir = rad2deg(position2D.get_rotation())
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if state == IDLE:
		if input_vector.x != 0 or input_vector.y != 0:
			animationPlayer.play(animMove)
		elif not rayCastWall.is_colliding():
			animationPlayer.play(animIdle)
		else:
			animationPlayer.play(animIdle)
	
	velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	velocity = move_and_slide(velocity)

func melee():
	animationPlayer.play("KnifeMelee")
	timer.start(idle_time)

func startReloading():
	animationPlayer.play(animReload)
	state = RELOADING

func dash():
	self.global_position = get_global_mouse_position()
#	get_viewport().warp_mouse(get_viewport().size / 2)

func grabWeapon(path):
	var weaponPicked = load(path)
	var currentWeapons = weapons.get_children()
	for weapon in currentWeapons:
		if path == str(weapon.filename):
			var t = str(weapon.name)
			grabAmmo(t, 60)  #If has the weapon give more ammo
			return
	# If not in inventory add weapon
	var wp = weaponPicked.instance()
	weapons.add_child(wp)
	var paths = str(get_path_to(spawnWeapons)) + "/" + str(wp.type)
	wp.global_position = get_node(paths).global_position
	weapons.updateWeaponsCarried()
	weapons.selectWeapon(weapons.weaponsCarried.size() - 1)

func grabAmmo(type, amount): 
	var wp = find_node(type, true, false)
	var currentWeapons = weapons.get_children()
	for weapon in currentWeapons:
		if weapon.name == type:
			wp.pickedAmmo(amount)

#	wp.pickedAmmo(amount)

func updateState():
	updateAnimations()

func stateIdle():
	state = IDLE
	rayCastWallCollision()

func stateShooting():
	state = SHOOTING
#	canShoot = false
func stateReloading():
	state = RELOADING

func updateAnimations():
	changeAnimation("Move")
	changeAnimation("Idle")
	changeAnimation("Shoot")
	changeAnimation("Reload")
	changeAnimation("Blocked")

func changeAnimation(value : String):
	if animationPlayer.has_animation(weapons.weaponSelected.name + value):
		set("anim" + value, weapons.weaponSelected.name + value) 
	else:
		set("anim" + value, weapons.weaponSelected.type + value)


func _on_HurtBox_area_entered(area):
	self.health -= area.damage
	health = clamp(health,0, 500)
	hurtbox.start_invincibility(0.3)
	modulate = Color(1.0, 0.0, 0.0, 1.0)
	if health <= 0 and state != DEAD:
		animationPlayer.play("Death")
		state = DEAD
#		death()
	elif state != DEAD:
		print(health)
		soundPain()

func bonusHeal(time):
#	print("healed")
	if not bonusHealing:
		bonusHealing = true
		healingTimer.start(time)
		if health < 100:
			self.health = 5
	
func _on_HealingTimer_timeout():
	bonusHealing = false

func death():
	soundDeath()
	emit_signal("player_death")
#	queue_free() # da un bug con los zombies

func soundPain():
	# load : get a filesystem and creates an object 
	audioPain.stream = load( "res://Characters/Player/Audio/%s.wav" %str(painSounds[randi() % painSounds.size()]) )
	audioPain.play()
	pass

	
func soundDeath():
#	audioPain.stream = load( "res://Characters/Player/Audio/%s.wav" %str(deathSounds[randi() % deathSounds.size()]) )
#	audioPain.play()
	pass

func getHealth():
	return health

func updateHealth(value):
	health = value
	emit_signal("updateHealthHUD", health)


func rayCastWallCollision():
	if rayCastWall.is_colliding():
		canShoot = false
		if state != BLOCKED:
			animationPlayer.play(animBlocked)
			state = BLOCKED
	elif state == BLOCKED:
		animationPlayer.play_backwards(animBlocked)

func _on_AnimationPlayer_animation_finished(_anim_name):
	if state != BLOCKED:
		stateIdle()

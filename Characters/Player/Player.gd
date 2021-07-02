extends KinematicBody2D

var Bullet = preload("res://World/Objects/Bullet.tscn")
var Muzzle = preload("res://World/Objects/Muzzle.tscn")
var PlayerCamera = preload("res://World/Camera.tscn")


export var speed = 1200
export var acceleration = 2500
export(float, 0.01, 0.5) var idle_time = 0.1
var canShoot = true
var automatic = false
var velocity = Vector2.ZERO
export var health = 100 setget updateHealth, getHealth
var bonusHealing = false
var distanceToBendBullet = 400

var minBulletSpdBonus = 0.3
var maxBulletSpdBonus = 1000

signal updateHUD(health, ammo, capacity)
#signal updateHealthHUD(health)
signal updateAmmo(ammo, capacity)
signal updateHUDWeapon(name)

onready var animationPlayer = $Position2D/AnimationPlayer
onready var position2D = $Position2D
onready var hurtbox = $HurtBox
onready var timer = $IdleTimer
onready var audioGuns = $AudioGuns
onready var audioPain = $AudioPain
onready var healingTimer = $HealingTimer
onready var remoteTransform = $RemoteTransform2D

onready var weapons = $Position2D/Weapons
onready var rifle = get_node("Position2D/Weapons/Rifle")
onready var pistol = get_node("Position2D/Weapons/Pistol")
onready var shotgun = get_node("Position2D/Weapons/Shotgun")
#onready var superShotgun = get_node("Position2D/Weapons/SuperShotgun")
onready var knife = $Position2D/Knife
onready var knifeCollision = $Position2D/Knife/Hitbox/CollisionShape2D
onready var rayCastWall = $Position2D/RayCastWall

enum {
	IDLE,
	SHOOTING,
	RELOADING,
	MELEE,
	BLOCKED,
}

var state = IDLE


onready var weaponSelected = rifle setget updateWeapon, getWeapon

onready var weaponSelectedAmmo = weaponSelected.ammo
onready var ammoSelected = weaponSelected.ammo

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
	connect("updateHUD", HUD, "_on_Player_updateHUD")
#	connect("updateHealthHUD", HUD, "_on_Player_updateHealth")
# warning-ignore:return_value_discarded
	connect("updateHUDWeapon", HUD, "_on_Player_updateHUDWeapon")
	randomize()
	get_tree().call_group("zombies", "set_player", self)
	knifeCollision.disabled = true
	updateHUD()

func _ready():
	yield(get_tree().create_timer(0.01), "timeout")
	var playerCamera = PlayerCamera.instance()
	get_parent().add_child(playerCamera)
	playerCamera.global_position = global_position
	remoteTransform.remote_path = "../../Camera"

var dir = 14

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Position2D.look_at(get_global_mouse_position())
	
	move(delta)
	
#	choose_weapon()
	if Input.is_action_just_pressed("change_weapon"):
		changeWeapon()
		
	match state:
		IDLE:
			rayCastWallCollision()
			
			if Input.is_action_pressed("shoot"):
#				trigger()
				weapons.trigger()
				checkWeapons()
			
			if not Input.is_action_pressed("shoot"):
				if not rayCastWall.is_colliding():
					canShoot = true
			
			if Input.is_action_just_pressed("knife"):
				melee()
				state = MELEE
			
			if Input.is_action_just_pressed("reload"):
#				weapons.reload() #
				if weaponSelected.reserveAmmo > 0:
					startReloading()
					state = RELOADING
		
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
	
	

func trigger():
	if not rayCastWall.is_colliding() and automatic:
		canShoot = true
	
	if canShoot and ammoSelected > 0 :
		animationPlayer.play(animShoot)
		state = SHOOTING
	elif ammoSelected == 0 and weaponSelected.reserveAmmo > 0:
		startReloading()
	else:
		state = IDLE
		

func shoot():
	for _i in range(weaponSelected.bulletsShot):
		var bullet = weaponSelected.AmmoShot.instance()
		get_parent().add_child(bullet)
		bullet.global_position = weaponSelected.global_position
#		bullet.damage = weaponSelected.damage
		bullet.hitbox.damage = weaponSelected.damage
		var miss = deg2rad(weaponSelected.missDegree)
#		var shotDirection = position2D.rotation + rand_range(- miss, miss)
		var baseDirection = position2D.rotation
		if global_position.distance_to(get_global_mouse_position()) > distanceToBendBullet :
			baseDirection = bullet.get_angle_to(get_global_mouse_position() + velocity / 10 ) + rand_range(- miss, miss)
			
		var shotDirection = baseDirection + rand_range(- miss, miss)
		bullet.direction = shotDirection
		bullet.get_node("Sprite").rotation_degrees = rad2deg(shotDirection)
		
		#add range to the bullet to compensate player movement
		var direction = Vector2( cos($Position2D.rotation) , sin($Position2D.rotation))
		var velocityVector = velocity.normalized()
		var velocityDot = velocityVector.dot(direction)
		var absVelocity = (abs(velocity.x) + abs(velocity.y))
		var isMovingFast = floor ( absVelocity  / 1200 )
		var inertiaSpeed = weaponSelected.weaponRange  * velocityDot * (.75 * isMovingFast)
		inertiaSpeed = clamp(inertiaSpeed, - weaponSelected.weaponRange * minBulletSpdBonus, maxBulletSpdBonus)
		bullet.bulletRange = weaponSelected.weaponRange  + inertiaSpeed
	muzzle()
	audioGuns.stream = weaponSelected.shotSound
	audioGuns.play()
	canShoot = false
#	timer.start(idle_time)
	self.weaponSelected.ammo -= 1

func melee():
	animationPlayer.play("KnifeMelee")
	timer.start(idle_time)

func _on_IdleTimer_timeout():
	pass
#	if not startedShooting:
#		canShoot = true

func startReloading():
	animationPlayer.play(animReload)
	state = RELOADING

func reload():
	fillAmmo()
	animationPlayer.play(animMove)
	state = IDLE

func fillAmmo():
	var reloadAmount = min(weaponSelected.capacity - weaponSelected.ammo, weaponSelected.reserveAmmo)
	self.weaponSelected.reserveAmmo -= reloadAmount
	self.weaponSelected.ammo +=  reloadAmount
#	self.weaponSelected.ammo = weaponSelected.capacity

func reloadSound():
	audioGuns.stream = weaponSelected.reloadSound
	audioGuns.play()

func grabAmmo(type, amount):
	get(type).pickedAmmo(amount) #Add ammo to weapon
	updateHUD()

func choose_weapon():
	if Input.is_action_just_pressed("pistol"):
		state = IDLE
		self.weaponSelected = pistol
	if Input.is_action_just_pressed("rifle"):
		state = IDLE
		self.weaponSelected = rifle
	if Input.is_action_just_pressed("shotgun"):
		self.weaponSelected = shotgun
#		self.weaponSelected = superShotgun
		state = IDLE
	updateState()
	emit_signal("updateHUDWeapon", str(weaponSelected.name) )

func updateState():
	automatic = weaponSelected.automatic
	self.ammoSelected = weaponSelected.ammo
	updateAnimations()

func stateIdle():
	state = IDLE
	if automatic == true:
		canShoot = true
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

func muzzle():
	var muzzle = Muzzle.instance()
	add_child(muzzle)
	muzzle.global_position = weaponSelected.global_position
	muzzle.rotation_degrees = position2D.rotation_degrees

func updateHUD():
	emit_signal("updateHUD", health, weaponSelected.ammo, weaponSelected.reserveAmmo)

func _on_HurtBox_area_entered(area):
	self.health = -area.damage
	hurtbox.start_invincibility(0.3)
	modulate = Color(1.0, 0.0, 0.0, 1.0)
	if health <= 0:
		death()
	else:
		soundPain()

func bonusHeal(time):
	if not bonusHealing:
		bonusHealing = true
		healingTimer.start(time)
		if health < 100:
			self.health = 5
	
func _on_HealingTimer_timeout():
	bonusHealing = false

func death():
	soundDeath()
	queue_free()

func soundPain():
	# load : get a filesystem and creates an object 
	audioPain.stream = load( "res://Characters/Player/Audio/%s.wav" %str(painSounds[randi() % painSounds.size()]) )
	audioPain.play()

	
func soundDeath():
	audioPain.stream = load( "res://Characters/Player/Audio/%s.wav" %str(deathSounds[randi() % deathSounds.size()]) )
	audioPain.play()

func getHealth():
	return health

func updateHealth(change):
	health += change
	updateHUD()

func updateWeapon(weapon):
	weaponSelected = weapon
	updateHUD()

func getWeapon():
	return weaponSelected

func addWeapon(weaponName : String):
#	weapons.add_child()
	pass

func rayCastWallCollision():
	if rayCastWall.is_colliding():
		canShoot = false
		if state != BLOCKED:
			animationPlayer.play(animBlocked)
			animationPlayer.advance(0.05)
			state = BLOCKED
	elif state == BLOCKED:
		animationPlayer.play_backwards(animBlocked)

func checkWeapons():
#	print(str(rifle.get_filename()))
#	var Test = load("res://Characters/Player/Top_Down_Survivor/" + weaponSelected.type.to_lower() + "/" + weaponSelected.name + ".tscn")

#	var test = Test.instance()
#	weapons.add_child(test)
#	test.global_position = global_position
#	var w = weapons.get_children()
#	for a in w.size():
#		print(w[a].name)
	pass

func changeWeapon():
	var weaponsCarried = weapons.get_children()
	for i in weaponsCarried.size():
		if weaponsCarried[i] == weaponSelected:
			var newWeapon
			if i + 1 < weaponsCarried.size():
				newWeapon = i + 1
			else:
				newWeapon = 0
			self.weaponSelected = weaponsCarried[newWeapon]
			print(i)
			break



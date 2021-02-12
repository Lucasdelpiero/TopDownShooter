extends KinematicBody2D

var Bullet = preload("res://World/Objects/Bullet.tscn")
var Muzzle = preload("res://World/Objects/Muzzle.tscn")
var PlayerCamera = preload("res://World/Camera.tscn")


export var speed = 1200
export var acceleration = 2500
export(float, 0.01, 0.5) var idle_time = 0.1
var shooting = false
var canShoot = true
var automatic = false
var velocity = Vector2.ZERO
export var health = 100 setget updateHealth, getHealth
var bonusHealing = false

var minBulletSpdBonus = 0.3
var maxBulletSpdBonus = 1000

signal updateHUD(health, ammo, capacity)
signal updateHealthHUD(health)
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

onready var rifle = $Position2D/Rifle
onready var pistol = $Position2D/Pistol
onready var shotgun = $Position2D/Shotgun
onready var knife = $Position2D/Knife
onready var knifeCollision = $Position2D/Knife/Hitbox/CollisionShape2D


onready var weaponSelected = rifle setget updateWeapon, getWeapon

onready  var pistolCapacity = 12
onready var pistolAmmo = pistolCapacity
onready var rifleCapacity = rifle.capacity
onready var rifleAmmo = rifle.ammo
export var shotgunCapacity = 8
onready var shotgunAmmo = shotgunCapacity
var reloading = false
onready var weaponSelectedAmmo = weaponSelected.ammo

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

onready var ammoSelected = rifleAmmo

var animMove = "RifleMove"
var animIdle = "RifleIdle"
var animShoot = "RifleShoot"
var animReload = "RifleReload"
var animMelee = "KnifeMelee"
var startedShooting = false


enum {
	PISTOL,
	RIFLE,
	SHOTGUN,
	KNIFE
}

var state = RIFLE

func _on_Player_tree_entered():
	yield(get_tree().create_timer(0.01), "timeout")
	var HUD = get_tree().get_root().find_node("HUD", true, false)
	connect("updateHUD", HUD, "_on_Player_updateHUD")
	connect("updateHealthHUD", HUD, "_on_Player_updateHealth")
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
#	updateHUD()
	dir = rad2deg(position2D.get_rotation())
	move(delta)
	
	choose_weapon()
	
	if Input.is_action_pressed("shoot"):
		if canShoot:
			trigger()
	else:
		shooting = false
		
	if Input.is_action_just_pressed("knife"):
		if not reloading:
			melee()
		else:
			reloading = false
			melee()
	if Input.is_action_just_pressed("reload"):
		startReloading()

func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if not reloading:
		if (not startedShooting) :
			if input_vector.x != 0 or input_vector.y != 0:
				animationPlayer.play(animMove)
			else:
				animationPlayer.play(animIdle)

	
	velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	velocity = move_and_slide(velocity)
	
	$Position2D.look_at(get_global_mouse_position())

func trigger():
	if canShoot and ammoSelected > 0 and not reloading:
		if (not shooting) or (shooting and automatic):
			animationPlayer.play(animShoot)
			startedShooting = true
	if ammoSelected == 0 and not shooting:
		startReloading()

func shoot():
	for i in range(weaponSelected.bulletsShot):
		var bullet = Bullet.instance()
		get_parent().add_child(bullet)
		bullet.global_position = weaponSelected.global_position
		var miss = deg2rad(weaponSelected.missDegree)
		var shotDirection = position2D.rotation + rand_range(- miss, miss)
		bullet.direction = shotDirection
		bullet.get_node("Sprite").rotation_degrees = rad2deg(shotDirection)
		
		#add range to the bullet
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
	shooting = true
	startedShooting = false
	timer.start(idle_time)
	self.weaponSelected.ammo -= 1
#	updateHUD()

func melee():
	canShoot = false
	shooting = true
	startedShooting = true
	animationPlayer.play("KnifeMelee")
	timer.start(idle_time)
	# reload after hitting an enemy

func _on_IdleTimer_timeout():
	if not startedShooting:
		canShoot = true

func startReloading():
	reloading = true
	animationPlayer.play(animReload)

func reload():
	fillAmmo()
	reloading = false
	animationPlayer.play(animMove)

func fillAmmo():
	self.weaponSelected.ammo = weaponSelected.capacity

func reloadSound():
	audioGuns.stream = weaponSelected.reloadSound
	audioGuns.play()

func choose_weapon():
	if not reloading:
		if Input.is_action_just_pressed("pistol"):
			state = PISTOL
			self.weaponSelected = pistol
		if Input.is_action_just_pressed("rifle"):
			state = RIFLE
			self.weaponSelected = rifle
		if Input.is_action_just_pressed("shotgun"):
			self.weaponSelected = shotgun
		updateState()
		emit_signal("updateHUDWeapon", str(weaponSelected.name) )

func updateState():
	automatic = weaponSelected.automatic
	self.ammoSelected = weaponSelected.ammo
	updateAnimations()

func updateAnimations():
	animMove = weaponSelected.name + "Move"
	animIdle = weaponSelected.name + "Idle"
	animShoot = weaponSelected.name + "Shoot"
	animReload = weaponSelected.name + "Reload"
	animMelee = weaponSelected.name + "Melee"

func muzzle():
	var muzzle = Muzzle.instance()
	add_child(muzzle)
	muzzle.global_position = weaponSelected.global_position
	muzzle.rotation_degrees = position2D.rotation_degrees

func resetVariables():
	canShoot = true
	shooting = false
	startedShooting = false

func updateHUD():
	emit_signal("updateHUD", health, weaponSelected.ammo, weaponSelected.capacity)

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

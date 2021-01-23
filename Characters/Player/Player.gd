extends KinematicBody2D

var Bullet = preload("res://World/Objects/Bullet.tscn")
var Muzzle = preload("res://World/Objects/Muzzle.tscn")

export var speed = 1200
export var acceleration = 2500
export(float, 0.01, 0.5) var idle_time = 0.1
var shooting = false
var canShoot = true
var automatic = false
var velocity = Vector2.ZERO
export var health = 100
var bonusHealing = false

signal updateHUD(health, ammo, capacity)
signal updateHUDWeapon(name)

onready var animationPlayer = $Position2D/AnimationPlayer
onready var position2D = $Position2D
onready var hurtbox = $HurtBox
onready var timer = $IdleTimer
onready var audioGuns = $AudioGuns
onready var healingTimer = $HealingTimer

onready var rifle = $Position2D/Rifle
onready var pistol = $Position2D/Pistol
onready var shotgun = $Position2D/Shotgun
onready var knife = $Position2D/Knife
onready var knifeCollision = $Position2D/Knife/Hitbox/CollisionShape2D


onready var weaponSelected = rifle

onready  var pistolCapacity = 12
onready var pistolAmmo = pistolCapacity
onready var rifleCapacity = rifle.capacity
onready var rifleAmmo = rifle.ammo
export var shotgunCapacity = 8
onready var shotgunAmmo = shotgunCapacity
var reloading = false

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

func _ready():
	get_tree().call_group("zombies", "set_player", self)
	knifeCollision.disabled = true
var dir = 14
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateHUD()
	dir = rad2deg(position2D.get_rotation())
	
	move(delta)
	
#	updateState()
	
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
#		reload()

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
	muzzle()
	audioGuns.stream = weaponSelected.shotSound
	audioGuns.play()
	canShoot = false
	shooting = true
	startedShooting = false
	timer.start(idle_time)
	weaponSelected.ammo -= 1
	updateHUD()

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
	weaponSelected.ammo = weaponSelected.capacity
	reloading = false
	animationPlayer.play(animMove)
	updateHUD()

func reloadSound():
	audioGuns.stream = weaponSelected.reloadSound
	audioGuns.play()

func choose_weapon():
	if not reloading:
		if Input.is_action_just_pressed("pistol"):
			state = PISTOL
			weaponSelected = pistol
		if Input.is_action_just_pressed("rifle"):
			state = RIFLE
			weaponSelected = rifle
		if Input.is_action_just_pressed("shotgun"):
			weaponSelected = shotgun
		updateState()
		emit_signal("updateHUDWeapon", str(weaponSelected.name) )

func updateState():
	automatic = weaponSelected.automatic
	ammoSelected = weaponSelected.ammo
#	audioGuns.stream = weaponSelected.shotSound
	updateAnimations()
	updateHUD()

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
	health -= area.damage
	hurtbox.start_invincibility(0.3)
	updateHUD()
	modulate = Color(1.0, 0.0, 0.0, 1.0)
	if health <= 0:
		queue_free()
#	hurtbox.create_hit_effect()
#	var playerHurtSound = PlayerHurtSound.instance()
#	get_tree().current_scene.add_child(playerHurtSound)

#reload when melee
func _on_Hitbox_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	weaponSelected.ammo = weaponSelected.capacity
#	health += 5
	bonusHeal(0.5)
	updateHUD()

func bonusHeal(time):
	if not bonusHealing:
		bonusHealing = true
		healingTimer.start(time)
		if health < 100:
			health += 5
	
func _on_HealingTimer_timeout():
	bonusHealing = false

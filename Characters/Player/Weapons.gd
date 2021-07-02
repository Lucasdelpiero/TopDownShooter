extends Node2D

export(NodePath) onready var mainP 
export(NodePath) onready var rayCastWallP
export(NodePath) onready var animationPlayerP
export(NodePath) onready var position2DP
export(NodePath) onready var audioGunsP

onready var main = get_node(mainP)
onready var rayCastWall = get_node(rayCastWallP)
onready var animationPlayer = get_node(animationPlayerP)
onready var position2D = get_node(position2DP)
onready var audioGuns = get_node(audioGunsP)

onready var weaponsCarried = get_children()

var canShoot = true

var automatic = false

onready var weaponSelected = weaponsCarried[0]
onready var ammoSelected = weaponSelected.ammo
signal updateHUDAmmo(ammo, capacity)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _on_Weapons_tree_entered():
	yield(get_tree().create_timer(0.01), "timeout")
	var HUD = get_tree().get_root().find_node("HUD", true, false)
	connect("updateHUDAmmo", HUD, "_on_Update_Ammo")
	emit_signal("updateHUDAmmo", "0", "44")
	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	choose_weapon()
	
#	if Input.is_action_pressed("shoot"):
#		trigger()
		
	if not Input.is_action_pressed("shoot"):
		if not rayCastWall.is_colliding():
			canShoot = true
	

func trigger():
	print("TRIGGERED")
	self.ammoSelected = weaponSelected.ammo
	if not rayCastWall.is_colliding() and automatic:
		canShoot = true
	print(ammoSelected)
	print(weaponSelected.name)
	if canShoot and ammoSelected > 0:
#		weaponSelected.shoot(main.velocity ,position2D.rotation)
		animationPlayer.play(main.animShoot)
		main.stateShooting()
	elif ammoSelected == 0 and weaponSelected.reserveAmmo > 0:
		startReloading()
	else:
#		main.state = IDLE
		pass

func shoot():
	print("SHOOTED")
	emit_signal("updateHUDAmmo", weaponSelected.ammo, weaponSelected.reserveAmmo)
	weaponSelected.shoot(main.velocity ,position2D.rotation)

func playSound(shotSound):
	audioGuns.stream = shotSound
	audioGuns.play()

func startReloading():
	animationPlayer.play(main.animReload)
	main.stateReloading()


func choose_weapon():
	weaponsCarried = get_children()
	if Input.is_action_just_pressed("pistol"):
		self.weaponSelected = weaponsCarried[0]
	if Input.is_action_just_pressed("rifle"):
		self.weaponSelected = weaponsCarried[1]
	if Input.is_action_just_pressed("shotgun"):
		self.weaponSelected = weaponsCarried[2]
#		self.weaponSelected = superShotgun
	updateState()
#	emit_signal("updateHUDWeapon", str(weaponSelected.name) )


func updateState():
#	automatic = weaponSelected.automatic
	self.ammoSelected = weaponSelected.ammo
	main.updateAnimations()




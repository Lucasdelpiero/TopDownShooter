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
onready var ammoSelected  = weaponSelected.ammo 
#ammoSelected = weaponSelected.ammo 
signal updateHUDAmmo(ammo, capacity)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _on_Weapons_tree_entered():
	yield(get_tree().create_timer(0.01), "timeout")
	var HUD = get_tree().get_root().find_node("HUD", true, false)
# warning-ignore:return_value_discarded
	connect("updateHUDAmmo", HUD, "_on_Update_Ammo")
	emit_signal("updateHUDAmmo", "0", "44")
	ammoSelected = weaponSelected.ammo 
	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready():
#	updateState()
	pass # Replace with function body.


func _physics_process(_delta):
	
	choose_weapon()
	
	if Input.is_action_just_pressed("change_weapon"):
		changeWeapon()
	
	if not Input.is_action_pressed("shoot"):
		if not rayCastWall.is_colliding():
			canShoot = true
	

func trigger():
	self.ammoSelected = weaponSelected.ammo
	if not rayCastWall.is_colliding() and automatic:
		canShoot = true

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
	weaponSelected.shoot(main.velocity ,position2D.rotation)
	updateAmmo()
	canShoot = false
	playSound(weaponSelected.shotSound)

func playSound(shotSound):
	audioGuns.stream = shotSound
	audioGuns.play()

func startReloading():
	animationPlayer.play(main.animReload)
	main.stateReloading()


func choose_weapon():
	weaponsCarried = get_children()
	if Input.is_action_just_pressed("pistol"):
		self.weaponSelected = weaponsCarried[1]
	if Input.is_action_just_pressed("rifle"):
		self.weaponSelected = weaponsCarried[0]
	if Input.is_action_just_pressed("shotgun"):
		self.weaponSelected = weaponsCarried[2]
#		self.weaponSelected = superShotgun
	updateState()
#	emit_signal("updateHUDWeapon", str(weaponSelected.name) )


func updateState():
	automatic = weaponSelected.automatic
	self.ammoSelected = weaponSelected.ammo
	main.updateAnimations()
	updateAmmo()

func updateAmmo():
	emit_signal("updateHUDAmmo", weaponSelected.ammo, weaponSelected.reserveAmmo)

func reloadSound():
	audioGuns.stream = weaponSelected.reloadSound
	audioGuns.play()

func reload():
	fillAmmo()
	main.stateIdle()
#	animationPlayer.play(animMove)
#	state = IDLE

func fillAmmo():
	var reloadAmount = min(weaponSelected.capacity - weaponSelected.ammo, weaponSelected.reserveAmmo)
	self.weaponSelected.reserveAmmo -= reloadAmount
	self.weaponSelected.ammo +=  reloadAmount
#	self.weaponSelected.ammo = weaponSelected.capacity

func changeWeapon():
#	var weaponsCarried = weapons.get_children()
	for i in weaponsCarried.size():
		if weaponsCarried[i] == weaponSelected:
			var newWeapon
			if i + 1 < weaponsCarried.size():
				newWeapon = i + 1
			else:
				newWeapon = 0
			self.weaponSelected = weaponsCarried[newWeapon]

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

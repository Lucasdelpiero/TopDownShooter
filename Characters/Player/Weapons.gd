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
signal updateHUDAmmo(ammo, capacity, reserve)

func _on_Weapons_tree_entered():
	yield(get_tree().create_timer(0.01), "timeout")
	var HUD = get_tree().get_root().find_node("HUD", true, false)
# warning-ignore:return_value_discarded
	connect("updateHUDAmmo", HUD, "_on_Update_Ammo")
	emit_signal("updateHUDAmmo", "0", "44", "55")
	ammoSelected = weaponSelected.ammo 

# Called when the node enters the scene tree for the first time.
func _ready():
#	updateState()
	pass # Replace with function body.

func _physics_process(_delta):
	
	choose_weapon()
	
	if not Input.is_action_pressed("shoot"):
		if not rayCastWall.is_colliding():
			canShoot = true

func _input(_event):
	if Input.is_action_pressed("wheel_up"):
		changeWeapon("next")
	if Input.is_action_pressed("wheel_down"):
		changeWeapon("previous")

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
	var pitchOffset = 0.1;
	audioGuns.pitch_scale = 1.0 + rand_range(-pitchOffset , pitchOffset)
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
	emit_signal("updateHUDAmmo", weaponSelected.ammo, weaponSelected.capacity,weaponSelected.reserveAmmo)

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

func changeWeapon(event : String):
	match event:
		"next":
			nextWeapon()
		"previous":
			previousWeapon()

func getCurrentWeapon():
	for i in weaponsCarried.size():
		if weaponsCarried[i] == weaponSelected:
			return i

func nextWeapon():
	var currentWeapon = getCurrentWeapon()
	if currentWeapon + 1 < weaponsCarried.size():
		selectWeapon(currentWeapon + 1) 
		return
	selectWeapon(0)

func previousWeapon():
	var currentWeapon = getCurrentWeapon()
	if currentWeapon - 1 >= 0:
		selectWeapon(currentWeapon - 1) 
		return
	selectWeapon( weaponsCarried.size() - 1 )

func selectWeapon(newWeapon):
	self.weaponSelected = weaponsCarried[ newWeapon ]

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

func updateWeaponsCarried():
	weaponsCarried = get_children()
	print(weaponsCarried)

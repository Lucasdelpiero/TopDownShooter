extends Position2D

var Muzzle = preload("res://World/Objects/Muzzle.tscn")

export(String, "Rifle", "Pistol", "Shotgun" ) var type = "Rifle"
export(PackedScene) var AmmoShot 
export var automatic = false
export var capacity = 12
onready var ammo = capacity
var reserveAmmo = capacity * 2
export var idleTime = 1.0
export var missDegree = 20
export var bulletsShot = 12
export var damage = 1
export var weaponRange = 2000

export var bulletsxFrame = 3

var distanceToBendBullet = 100
var minBulletSpdBonus = 0.3
var maxBulletSpdBonus = 1000

export(Resource) var shotSound 
export(Resource) var reloadSound


func _ready():
	reserveAmmo = capacity * 2

func pickedAmmo(amount):
	reserveAmmo += amount

func trigger():
	if automatic:
		pass

func shoot(vel : Vector2, rot):
	for i in range(bulletsShot):
		if (i % bulletsxFrame) == 0 :
			yield(get_tree().create_timer(0.01),"timeout")
		
		var velocity = vel
		var bullet = AmmoShot.instance()
#		get_tree().get_root().add_child(bullet)
		get_tree().get_nodes_in_group("world")[0].add_child(bullet)
		bullet.global_position = global_position
#		bullet.damage = weaponSelected.damage
		bullet.hitbox.damage = damage
		var miss = deg2rad(missDegree)
#		var shotDirection = position2D.rotation + rand_range(- miss, miss)
		var baseDirection = rot
		if global_position.distance_to(get_global_mouse_position()) > distanceToBendBullet : #Corrects the angle to shoot to the enemy
			baseDirection = bullet.get_angle_to(get_global_mouse_position() + velocity / 10 ) + rand_range(- miss, miss)
		var shotDirection = baseDirection + rand_range(- miss, miss)
		bullet.direction = shotDirection
		bullet.get_node("Sprite").rotation_degrees = rad2deg(shotDirection)
		
		#add range to the bullet to compensate player movement
		var direction = Vector2( cos(rot) , sin((rot)))
		var velocityVector = velocity.normalized()
		var velocityDot = velocityVector.dot(direction)
		var absVelocity = (abs(velocity.x) + abs(velocity.y))
		var isMovingFast = floor ( absVelocity  / 1200 )
		var inertiaSpeed = weaponRange  * velocityDot * (.75 * isMovingFast)
		inertiaSpeed = clamp(inertiaSpeed, - weaponRange * minBulletSpdBonus, maxBulletSpdBonus)
		bullet.bulletRange = weaponRange  + inertiaSpeed
	muzzle(rot)
	

#	canShoot = false  #

	self.ammo -= 1 #

func muzzle(rot):
	var muzzle = Muzzle.instance()
	get_tree().get_nodes_in_group("world")[0].add_child(muzzle)
	muzzle.global_position = global_position
	muzzle.rotation_degrees = rot

func sound():
	get_parent().playSound(shotSound)


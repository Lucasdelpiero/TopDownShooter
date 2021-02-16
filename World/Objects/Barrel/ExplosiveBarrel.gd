extends KinematicBody2D

export var health = 2
var exploted = false
onready var Explosion = preload("res://World/Objects/Barrel/Explosion.tscn")
onready var BarrelDown = preload("res://World/Objects/Barrel/barrel_exp_down 197x128.png")
onready var ShapeRectangle = preload("res://World/Objects/Barrel/shapeRectangle.tres")
onready var FireParticle = preload("res://World/Objects/Barrel/FireParticle.tscn")
onready var audioStreamPlayer = $AudioStreamPlayer
onready var timer = $Timer
onready var sprite = $Sprite
onready var areaCollision = $HurtBox/CollisionShape2D
onready var areaCollisionRolling = $HurtBox/CollisionRolling
onready var collisionShape = $CollisionShape2D
onready var collisionShapeRolling = $CollisionRolling
export var speed = 500
var direction = Vector2.ZERO
var collision = false
var moving = false
var onFire = false

var soundsHitted = [
	"barrel_shot_1",
	"barrel_shot_2",
]

func _ready():
	randomize()

func _physics_process(delta):
#	velocity = velocity.move_toward(direction * speed, delta)
	if moving:
		var vector = Vector2( cos(direction), sin(direction) )
#		velocity = move_and_slide(vector * speed)
		collision = move_and_collide(vector * speed * delta)
		if collision:
			moving = false
			if onFire:
				createExplosion()
#		if collisionShape.is_colliding():
#			pass

func _on_HurtBox_area_entered(area):
	if not onFire:
		setOnFire()
	if area.is_in_group("Melee"):
		direction = area.get_parent().get_parent().rotation
		rotation = direction
		sprite.texture = BarrelDown
		moving = true
		toggleCollisionShape()

	else:
		health -= area.damage
		audioStreamPlayer.stream = load( "res://World/Objects/Barrel/%s.wav" %str(soundsHitted[randi() % soundsHitted.size()]) ) 
		audioStreamPlayer.play()

	if health < 1 and not exploted:
		#Called deferred because of a bug
		exploted = true
#		call_deferred("createExplosion")
		timer.start(rand_range(0.0, 0.3))

func setOnFire():
	var fireParticle = FireParticle.instance()
	add_child(fireParticle)
	fireParticle.global_position = global_position
	onFire = true
	timer.start(rand_range(2, 3))

func createExplosion():
	var explosion = Explosion.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()

func toggleCollisionShape():
	areaCollision.set_shape(ShapeRectangle)

func _on_Timer_timeout():
	createExplosion()

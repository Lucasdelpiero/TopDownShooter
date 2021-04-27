extends KinematicBody2D

export var speed = 50.0
onready var sprite = $Sprite
onready var direction = 1 # rotation_degrees
var velocity = Vector2.ZERO
var motion = Vector2.ZERO
onready var rayCast = $Sprite/RayCast2D
onready var audio = $AudioStreamPlayer
onready var timer = $Timer
var collided = false
var bulletRange = 0
var ready = false

# Called when the node enters the scene tree for the first time.
#func _ready():
#	direction = get_angle_to(get_global_mouse_position())
#	sprite.rotation_degrees = rad2deg(direction)

var bulletHitWall = [
	"bullet_hit_wall_1",
	"bullet_hit_wall_2",
]


func _physics_process(delta):
	if not ready:
		setLifeTime(delta)
	move(delta)

	

func move(_delta):
	
	motion.x = speed * cos(direction)
	motion.y = speed * sin(direction)
	move_and_collide(motion)
	if rayCast.is_colliding() and not collided:
		audio.stream = load ("res://World/Objects/%s.wav" % str(bulletHitWall[ randi() % bulletHitWall.size() ] ) )
		audio.play()
		speed = 0
		timer.start(0.5)
		sprite.visible = false
		collided = true
#		queue_free()

func _on_Timer_timeout():
	queue_free()

func _on_Hitbox_area_entered(_area):
	queue_free()

func setLifeTime(delta):
	var bulletTime = ( bulletRange / speed * delta )
	timer.set_wait_time(bulletTime)
	if timer.is_stopped():
		timer.start()
	ready = true

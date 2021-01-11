extends KinematicBody2D

export var speed = 50.0
onready var sprite = $Sprite
onready var direction = 1 # rotation_degrees
var velocity = Vector2.ZERO
var motion = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
#func _ready():
#	direction = get_angle_to(get_global_mouse_position())
#	sprite.rotation_degrees = rad2deg(direction)



func _process(delta):
	move(delta)
	

func move(delta):
	motion.x = speed * cos(direction)
	motion.y = speed * sin(direction)
	move_and_collide(motion)


func _on_Timer_timeout():
	queue_free()

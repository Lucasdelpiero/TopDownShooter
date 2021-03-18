extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
export var speed = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	set_bounce(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	set_bounce(0)
#	if Input.is_action_just_pressed("knife"):
#		activate()

func push():
	linear_velocity = Vector2(-cos(rotation) * speed, -sin(rotation) * speed)

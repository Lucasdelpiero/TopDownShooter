extends RigidBody2D

export var default_sprite : Texture
export var fat_sprite : Texture
export(String, "zombi", "zombiFat", "zombiFast", "zombiExplosive") var type = "zombi"
export var speed = 100
onready var sprite = $ZombiDead/Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	set_bounce(0)
	if type == "zombiFat" and fat_sprite != null:
		sprite.texture = fat_sprite
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	set_bounce(0)
#	if Input.is_action_just_pressed("knife"):
#		activate()

func push():
	linear_velocity = Vector2(-cos(rotation) * speed, -sin(rotation) * speed)

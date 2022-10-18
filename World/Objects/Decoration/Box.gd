extends StaticBody2D

onready var sprite = $AnimatedSprite
var numSprites = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	setRandomSprite()
#	print(sprite.frames.get_frame_count("default"))
	pass # Replace with function body.



func setRandomSprite():
	numSprites = sprite.frames.get_frame_count("default") 
	sprite.frame = randi() % numSprites
	sprite.rotation_degrees = (randi() % 5 ) * 90
	pass

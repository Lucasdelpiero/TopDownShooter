extends Control



onready var sprite = $Sprite
var camera = null


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.1),"timeout")
	camera = get_tree().get_root().find_node("Camera", true, false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	global_position = Vector2(0,0) + get_local_mouse_position().normalized() * 50
	sprite.global_position = get_global_mouse_position()
	var a = 1 
	if camera != null:
		a = camera.zoom.x
	sprite.scale = Vector2(a  , a )
	pass

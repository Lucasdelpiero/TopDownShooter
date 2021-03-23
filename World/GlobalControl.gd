extends Node



var crosshair = preload("res://HUD/crosshair.png")
var offset = 16




# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_ARROW, Vector2(offset, offset))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

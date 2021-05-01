extends Node



var crosshair = preload("res://HUD/Sprites/crosshair.png")
var offset = 16

var max_scores = {
	"PrototypeLevel" : 0,
	"PrototypeLevel2" : 0,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_ARROW, Vector2(offset, offset))
	pass # Replace with function body.


func update_max_score(name, score):
	max_scores[name] = score
	print(max_scores)
	print(max_scores.values())

	pass

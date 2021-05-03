extends Node



var crosshair = preload("res://HUD/Sprites/crosshair.png")
var offset = 16

var max_score = {
	"PrototypeLevel" : {"score" : 0},
	"PrototypeLevel2" : {"score" : 0},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_ARROW, Vector2(offset, offset))
	pass # Replace with function body.


func update_max_score(name, aScore, aCombo, aTime, tKilled, tMelee, tExplosion):
	max_score[name].score = aScore
	max_score[name].combo = aCombo
	max_score[name].time = aTime
	max_score[name].killed = tKilled
	max_score[name].melee = tMelee
	max_score[name].explosion = tKilled
	
	print(max_score)

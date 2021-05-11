extends Node



var crosshair = preload("res://HUD/Sprites/crosshair.png")
var offset = 16

var max_score = {
#	"PrototypeLevel" : {"score" : 0},
#	"PrototypeLevel2" : {"score" : 0},
#	"ExteriorTest" : {"score" : 0},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_ARROW, Vector2(offset, offset))
	pass # Replace with function body.


func update_max_score(results : Dictionary):
	if not max_score.has("name"): #If the directory to the level scores doesnt exits, it creates one
		max_score[ results["name"] ] = {}
	
	max_score[ results["name"] ].score = results["score"]
	max_score[ results["name"] ].combo = results["maxCombo"]
	max_score[ results["name"] ].time = results["time"]
	max_score[ results["name"] ].killed = results["totalKilled"]
	max_score[ results["name"] ].melee = results["totalMelee"]
	max_score[ results["name"] ].explosion = results["totalKilled"]
	
	print(max_score)


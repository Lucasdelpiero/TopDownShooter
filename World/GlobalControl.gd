extends Node

var world = null
var pausable = false

#var crosshair = preload("res://HUD/Sprites/crosshair.png")
var offset = 16

var max_score = {
#	"PrototypeLevel" : {"score" : 0},
#	"PrototypeLevel2" : {"score" : 0},
#	"ExteriorTest" : {"score" : 0},
}

# Called when the node enters the scene tree for the first time.
func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_ARROW, Vector2(offset + 5, offset))
#	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_CROSS, Vector2(offset + 5, offset))
	pass # Replace with function body.
#

var timeSlow = false

func _input(_event):
	if Input.is_action_just_pressed("special"):
		if timeSlow == false:
			Engine.time_scale = 0.3 
			timeSlow = true
		else:
			Engine.time_scale = 1.0
			timeSlow = false

func showMouse(value : bool):
	if value == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

func update_max_score(results : Dictionary):
	if not max_score.has("name"): #If the directory to the level scores doesnt exits, it creates one
		max_score[ results["name"] ] = {}
	
	#################
	# This can be done better (inser the dictionary maybe? or copy)
	################
	max_score[ results["name"] ].score = results["score"]
	max_score[ results["name"] ].combo = results["maxCombo"]
	max_score[ results["name"] ].time = results["time"]
	max_score[ results["name"] ].killed = results["totalKilled"]
	max_score[ results["name"] ].melee = results["totalMelee"]
	max_score[ results["name"] ].explosion = results["totalKilled"]
	
	print(max_score)

func giveScore(key):
	if max_score.has(key):
		return max_score[key]["score"]
	else:
		return "0"
	pass

#func addCrosshair():
#	var crosshair = CrossHair.instance
#	add_child(crosshair)

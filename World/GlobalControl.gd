extends Node

var world = null

#var crosshair = preload("res://HUD/Sprites/crosshair.png")
var offset = 16
var levels = []
var levelSelected = 0

var max_score = {
#	{Level_1:{completed:True, maxCombo:3, score:300, time:8,
#    totalExplosion:0, totalKilled:3, totalMelee:2}} example

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
	if Input.is_action_just_pressed("jump"):
		print(levels)
	
#func _input(event):
#	if event.is_action_pressed("paused"):
#		var new_pause_state = not get_tree().paused
#		get_tree().paused = new_pause_state
#		showMouse(new_pause_state)

func showMouse(value : bool):
	if value == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

func update_max_score(results : Dictionary):
	if not max_score.has("name"): #If the directory to the level scores doesnt exits, it creates one
		max_score[ results["name"] ] = {}
#		print("before")
#		print(max_score)
		var res = results.duplicate(true)
#		res.erase("name")
#		max_score = { results["name"] : res} # replaced everything
		max_score[results["name"]] =  res 
#		print("after")
#		print(max_score)
	

func giveScore(key):
	if max_score.has(key):
		return max_score[key]["score"]
	else:
		return "0"
	pass

#func addCrosshair():
#	var crosshair = CrossHair.instance
#	add_child(crosshair)

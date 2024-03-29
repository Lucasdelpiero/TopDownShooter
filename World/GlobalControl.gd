extends Node

var world = null

#var crosshair = preload("res://HUD/Sprites/crosshair.png")
var offset = 16
var levels = []
var levelSelected = 0
var next_level : PackedScene
var language_was_selected = false

var Z_INDEX = {
	"GROUND": 0,
	"FLOOR_DECORATION" : 10,
	"MID_DECORATION" : 8,
	"CORPSE" : 20,
	"ZOMBI" : 40,
	"CHARACTER" : 50,
	"WALL" : 80,
}

var max_score = {
#	{Level_1:{completed:True, maxCombo:3, score:300, time:8,
#    totalExplosion:0, totalKilled:3, totalMelee:2}} example

}


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_fullscreen(true)
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
#		goto_next_level()
		pass
	
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
func goto_next_level():
	get_tree().change_scene_to(next_level)
	return
	var _levels = GlobalControl.levels
	var currentWorld = get_tree().get_nodes_in_group("world")[0]
	var worldName = currentWorld.name
	for i in levels.size():
		if i == levels.size() - 1: # Safeguard
			get_tree().change_scene("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")
			break

		if worldName == levels[i]:
			var nextLevel = "res://World/Maps/" + levels[i + 1] + ".tscn"
			get_tree().change_scene(nextLevel)
			break
	if levels.size() == 0: # Used only when a level is loaded without going through the level selector, as the list is loaded in that scene
		get_tree().change_scene("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")
	

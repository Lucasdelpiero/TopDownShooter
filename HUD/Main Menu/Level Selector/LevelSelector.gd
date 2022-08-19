extends Control


var levelPaths = [
#	"PrototypeLevel",
#	"PrototypeLevel2",
#	"ExteriorTest",
#	"PrototypeLevel2",
#	"PrototypeLevel2",
#	"PrototypeLevel2",
#	"PrototypeLevel2",
#	"PrototypeLevel2",
#	"PrototypeLevel2",
] 

var levelsList = []
var levelNames = []
var levelTextures = []

var levelDiamond = []
var levelCompleted = []

var levelSelected = 0 # level targeted to play

#onready var levelLabel = $PanelContainer/VBoxContainer/LevelLabel
#onready var picture = $LevelPicture
#onready var allLevels = $DiamondParent
export(NodePath) var PallLevels = null
var allLevels = null
export(NodePath) var PlevelLabel = null
var levelLabel = null
export(NodePath) var PPicture = null
var picture = null
export(NodePath) var PmaxScoreL
var maxScoreL = null

onready var levelGroup = $LevelGroup
onready var levels = []

#onready var maxScoreL = get_node(maxScoreLPath)

# Called when the node enters the scene tree for the first time.
func _ready():
	allLevels = get_node(PallLevels)
	levelLabel = get_node(PlevelLabel)
	picture = get_node(PPicture)
	maxScoreL = get_node(PmaxScoreL)
	levels = levelGroup.get_children()
	
	maxScoreL.text = "Max Score: "
	levelDiamond = allLevels.get_children()
	pull_data_from_levels()
	readyLevel() # Select a level at the start of the game
	test()
	updateInfo()

func readyLevel():
	# An animation could be made here
	var targetLevel = GlobalControl.levelSelected
	if targetLevel < levelNames.size():
		levelSelected = targetLevel


func startGame():
	var map = "res://World/Maps/" +  levelPaths[levelSelected] + ".tscn"
	get_tree().change_scene(map)

func updateInfo():
#	levelLabel.text = "Level: " + levelName[levelSelected]
#	picture.set_texture(load(levelPic[levelSelected])) 
	levelLabel.text = "Level: " + levelNames[levelSelected]
	picture.set_texture(levelTextures[levelSelected])
	for i in levelDiamond.size():
		levelDiamond[i].pressed = false
#		levelLocking(i)
		
	levelDiamond[levelSelected].pressed = true
	updateScoreLabel()
	updateLevelLocking()

# Unlocks levels once the past one had been cleared
func updateLevelLocking(): 
	# Diamonds locks
	for i in levels.size():
		if i > 0:
#			levelDiamond[i].disabled = true # default value
			levelDiamond[i].modulate = Color(1.0, 1.0, 1.0, 0.4) # default value
			
			var levelBefore = levels[i - 1].levelName
			# Level is unlocked
			if GlobalControl.max_score.has(levelBefore):
				if GlobalControl.max_score[levelBefore].completed == true :
#					levelDiamond[i].disabled = false
					levelDiamond[i].modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	# Start button lock
	$StartButton.disabled = false
	if levelSelected > 0:
		if !GlobalControl.max_score.has(levels[levelSelected - 1].levelName):
			print(GlobalControl.max_score)
			$StartButton.disabled = true




func levelLocking(arg):
	pass
#	print(arg)
#	if int(GlobalControl.giveScore(levelPaths[arg])) == 0 and arg != 0:
#		if int(GlobalControl.giveScore(levelPaths[arg - 1])) == 0:
#			levelDiamond[arg].disabled = true
#			levelDiamond[arg].modulate = Color(1.0, 1.0, 1.0, 0.4)
#			print("no score")

func updateScoreLabel():
	##################################################################
	# REFACTOR
	##########################################################################
	var scoreLevel = GlobalControl.giveScore(levelPaths[levelSelected]) 
	######################################################################
	maxScoreL.text = "Max Score: " + str(scoreLevel)

func _on_PreviousButton_pressed():
	if levelSelected > 0:
		levelSelected -= 1
	else:
		levelSelected = levelPaths.size() - 1
	updateInfo()

func _on_NextButton_pressed():
	if levelSelected < (levelPaths.size() - 1):
		levelSelected += 1
	else:
		levelSelected = 0
	updateInfo()

func _on_StartButton_pressed():
	startGame()

func _on_diamond_chosen(name):
	for i in levelDiamond.size():
		if levelDiamond[i].name != name:
			levelDiamond[i].pressed = false
		else:
			levelSelected = i
			updateInfo()

func test():
#	var scores = GlobalControl.max_score["PrototypeLevel"].score
#	$label1.text = "Prototype: " + str(GlobalControl.max_score["PrototypeLevel"].score)
#	$Label2.text = "Prototype2: " + str(scores[1])
	pass
	

func pull_data_from_levels():
	levelNames = levelGroup.nameTags
	levelPaths = levelGroup.paths
	levelTextures = levelGroup.textures


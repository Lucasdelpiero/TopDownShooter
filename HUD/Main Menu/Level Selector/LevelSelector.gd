extends Control


var levelPaths = [
	"PrototypeLevel",
	"PrototypeLevel2",
	"ExteriorTest",
	"PrototypeLevel2",
	"PrototypeLevel2",
	"PrototypeLevel2",
	"PrototypeLevel2",
	"PrototypeLevel2",
	"PrototypeLevel2",
] 

var levelsList = []
var levelNames = []
var levelTextures = []

var levelDiamond = []

var levelSelected = 0

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
#onready var maxScoreL = get_node(maxScoreLPath)

# Called when the node enters the scene tree for the first time.
func _ready():
	allLevels = get_node(PallLevels)
	levelLabel = get_node(PlevelLabel)
	picture = get_node(PPicture)
	maxScoreL = get_node(PmaxScoreL)
	
	maxScoreL.text = "Max Score: "
	levelDiamond = allLevels.get_children()
	pull_data_from_levels()
	test()
	updateInfo()


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
	levelDiamond[levelSelected].pressed = true
	updateScoreLabel()

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


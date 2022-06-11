extends Control


var levelList = [
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

export(Array, PackedScene) var levelsList = []

export(Array, String) var levelNames = []

export(Array, Texture) var textures = []

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

onready var LevelList = $LevelList
#onready var maxScoreL = get_node(maxScoreLPath)

# Called when the node enters the scene tree for the first time.
func _ready():
	allLevels = get_node(PallLevels)
	levelLabel = get_node(PlevelLabel)
	picture = get_node(PPicture)
	maxScoreL = get_node(PmaxScoreL)
	
	maxScoreL.text = "Max Score: "
	levelDiamond = allLevels.get_children()
	updateInfo()
	test()


func startGame():
	var map = "res://World/Maps/" +  levelList[levelSelected] + ".tscn"
	print(map)
	print(levelNames[levelSelected])
	get_tree().change_scene_to(levelsList[levelSelected])
# warning-ignore:return_value_discarded
#	get_tree().change_scene(map)
	pass

func updateInfo():
#	levelLabel.text = "Level: " + levelName[levelSelected]
#	picture.set_texture(load(levelPic[levelSelected])) 
	levelLabel.text = "Level: " + levelNames[levelSelected]
	picture.set_texture(textures[levelSelected])
	for i in levelDiamond.size():
		levelDiamond[i].pressed = false
	levelDiamond[levelSelected].pressed = true
	updateScoreLabel()

func updateScoreLabel():
	##################################################################
	# REFACTOR
	##########################################################################
	var scoreLevel = GlobalControl.giveScore(levelList[levelSelected]) 
	######################################################################
	maxScoreL.text = "Max Score: " + str(scoreLevel)

func _on_PreviousButton_pressed():
	if levelSelected > 0:
		levelSelected -= 1
	else:
		levelSelected = levelList.size() - 1
	updateInfo()

func _on_NextButton_pressed():
	if levelSelected < (levelList.size() - 1):
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
	pass



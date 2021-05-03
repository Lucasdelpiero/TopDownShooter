extends Control

var levelList = [
	"PrototypeLevel",
	"PrototypeLevel2",
	"PrototypeLevel2",
	"PrototypeLevel2",
	"PrototypeLevel2",
	"PrototypeLevel2",
	"PrototypeLevel2",
] 
var levelName = [
	"Tutorial",
	"Nice",
	"Yeah",
	"Haha",
	"nnffn",
	"hhffh",
	"hh",
	"hffhh",
]

var levelPic = [
	"res://HUD/Main Menu/Images Levels/testLevelPic.png",
	"res://HUD/Weapons/ak47_icon.png",
	"res://World/Objects/128x72.png",
	"res://HUD/Main Menu/Images Levels/testLevelPic.png",
	"res://HUD/Weapons/ak47_icon.png",
	"res://World/Objects/128x72.png",
	"res://HUD/Main Menu/Images Levels/testLevelPic.png",
	"res://HUD/Main Menu/Images Levels/testLevelPic.png",
	"res://HUD/Main Menu/Images Levels/testLevelPic.png",
	"res://HUD/Main Menu/Images Levels/testLevelPic.png",
	"res://HUD/Main Menu/Images Levels/testLevelPic.png",
	"res://HUD/Main Menu/Images Levels/testLevelPic.png",
]

var levelDiamond = []

var levelSelected = 0

onready var levelLabel = $PanelContainer/VBoxContainer/LevelLabel
onready var picture = $LevelPicture
onready var allLevels = $DiamondParent
# Called when the node enters the scene tree for the first time.
func _ready():
	levelDiamond = allLevels.get_children()
	updateInfo()
	test()

func startGame():
	var map = "res://World/Maps/" +  levelList[levelSelected] + ".tscn"
	print(map)
	get_tree().change_scene(map)
	pass

func updateInfo():
	levelLabel.text = "Level: " + levelName[levelSelected]
	picture.set_texture(load(levelPic[levelSelected])) 
	for i in levelDiamond.size():
		levelDiamond[i].pressed = false
	levelDiamond[levelSelected].pressed = true

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
	$label1.text = "Prototype: " + str(GlobalControl.max_score["PrototypeLevel"].score)
#	$Label2.text = "Prototype2: " + str(scores[1])
	




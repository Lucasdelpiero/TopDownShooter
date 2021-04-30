extends Control

var levelList = [
	"res://World/Maps/PrototypeLevel.tscn",
	"res://World/Maps/PrototypeLevel2.tscn",
	"res://World/Maps/PrototypeLevel2.tscn",
	"res://World/Maps/PrototypeLevel2.tscn",
	"res://World/Maps/PrototypeLevel2.tscn",
	"res://World/Maps/PrototypeLevel2.tscn",
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

func startGame():
	get_tree().change_scene(levelList[levelSelected])
	pass

func updateInfo():
	levelLabel.text = "Level: " + levelName[levelSelected]
	picture.set_texture(load(levelPic[levelSelected])) 

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
	print(levelSelected)
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

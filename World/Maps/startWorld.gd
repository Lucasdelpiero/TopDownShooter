extends Node2D

var HUD = preload("res://HUD/HUD.tscn")
var Darkness = preload("res://HUD/Darkness.tscn")
var OptionsLayer = preload("res://HUD/Main Menu/Options.tscn")


onready var zombies = []
onready var player = find_node("Player")
onready var navPolygon = "res://Characters/zombi/zombiNavigationPolygon.tres"
export(PackedScene) var next_level = load("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")
#onready var background = $TileMaps/DarkBackground
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	GlobalControl.showMouse(false)
	GlobalControl.next_level = next_level
	create(HUD)
	create(Darkness)
	create(OptionsLayer)
	var scoring = find_node("Scoring", true , false)
	scoring.levelName = name
	GlobalControl.world = self

func create(resource):
	var node = resource.instance()
	add_child(node)


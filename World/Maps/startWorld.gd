extends Node2D

var HUD = preload("res://HUD/HUD.tscn")
var PauseScreen = preload("res://HUD/PauseScreen.tscn")
var Darkness = preload("res://HUD/Darkness.tscn")
var OptionsLayer = preload("res://HUD/Main Menu/Options.tscn")


onready var nav2D : Navigation2D = $Navigation2D
onready var zombies = []
onready var player = find_node("Player")
onready var navPolygon = "res://Characters/zombi/zombiNavigationPolygon.tres"
# Called when the node enters the scene tree for the first time.
func _ready():
	create(HUD)
	create(PauseScreen)
	create(Darkness)
	create(OptionsLayer)
	


func create(resource):
	var node = resource.instance()
	add_child(node)
#	for zombi in zombies:
#		var navZombi = NavigationPolygonInstance.new()
#		nav2D.add_child(navZombi)
#		navZombi.navpoly = navPolygon
#		navZombi.global_position = zombi.global_position
#

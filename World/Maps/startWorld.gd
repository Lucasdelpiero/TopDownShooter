extends Node2D

var HUD = preload("res://HUD/HUD.tscn")
var PauseScreen = preload("res://HUD/PauseScreen.tscn")
var Darkness = preload("res://HUD/Darkness.tscn")
var OptionsLayer = preload("res://HUD/Main Menu/Options.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	create(HUD)
	create(PauseScreen)
	create(Darkness)
	create(OptionsLayer)

func create(res):
	var node = res.instance()
	add_child(node)

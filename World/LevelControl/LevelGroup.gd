extends Node

var nameTags : = []
var paths : = []
var textures : = []

func _ready():
	for i in get_children():
		var levelName = i.levelPath._bundled.names[0] # Gets name of the level (PackedScene)
		nameTags.append(i.nameTag)
		paths.append(levelName)
		textures.append(i.texture)



extends Node


var nameTags : = []
var levelPaths : = []
var textures : = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		nameTags.append(i.nameTag)
		levelPaths.append(i.levelPath)
		textures.append(i.texture)
	print(nameTags)
	print(levelPaths)
	print(nameTags)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

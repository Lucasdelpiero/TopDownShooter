extends Node

export(String) var nameTag = "Unnamed"
export(PackedScene) var levelPath = null
export(Texture) var texture = null
export(bool) var completed = false

onready var levelName = null # gets the name of the packedScene

func _ready():
	levelName = levelPath._bundled.names[0]

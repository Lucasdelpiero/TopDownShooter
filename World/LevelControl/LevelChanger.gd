extends Area2D

export(Resource) var scene = null
export var targetSpawn = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LevelChanger_body_entered(_body):
	changeLevel()

func changeLevel():
# warning-ignore:return_value_discarded
	pass
	if scene != null:
		var targetScene = scene.get_path()
		print(targetScene)
		get_tree().change_scene(targetScene) 
	else:
		print("There is no level loaded")

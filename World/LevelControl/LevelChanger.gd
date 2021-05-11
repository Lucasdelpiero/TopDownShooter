extends Area2D

export(String) var targetScene  
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
	get_tree().change_scene(targetScene) 


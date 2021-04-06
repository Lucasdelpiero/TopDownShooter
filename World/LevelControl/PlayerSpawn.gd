extends Position2D

export(int) var spawnID = 1

onready var Player = preload("res://Characters/Player/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func spawnPlayer():
	var player = Player.instance()
	get_tree().add_child(player)
	player.global_position = global_position
	pass

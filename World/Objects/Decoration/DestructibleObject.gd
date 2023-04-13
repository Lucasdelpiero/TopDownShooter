extends Node2D

export(Resource) var ParticleScene 
export(Color) var particleColor 

var particleNode = null
var world = null



# Called when the node enters the scene tree for the first time.
func _ready():
	var p = ParticleScene.get_path()
#	print(p)
	yield(get_tree().create_timer(1.0), "timeout")
	## If exist world get it location
	var arrWorld = get_tree().get_nodes_in_group("world")
	if arrWorld.size() > 0:
		world == arrWorld[0]
#	print(world)
	destroy()
	pass # Replace with function body.


func destroy():
#	queue_free()
	var particles = load(ParticleScene.get_path()).instance()
#	world.add_child(particles)
#	particles.global_position = global_position
	


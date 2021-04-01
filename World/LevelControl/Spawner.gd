extends Node2D

var zombiCap = 60
export(Resource) var enemy0 = null
export(int,1, 50) var amount0 
export(Resource) var enemy1 = null
export(int,1, 50) var amount1 
export(Resource) var enemy2 = null
export(int,1, 50) var amount2 

export(bool) var continuous = false
export(bool) var turnOnAllDied = false
export(bool) var autoStart = false
export(float, 1.0, 60.0, 1.0) var timerTime 

var enemies : Array 
var enemiesAmount : Array
var spawning = false
var randomRange = 128

onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	enemies = [enemy0, enemy1, enemy2]
	enemiesAmount = [amount0, amount1, amount2]
	
	timer.one_shot = not continuous

	if not turnOnAllDied:
		timer.wait_time = timerTime
	if autoStart:
		timer.start()
	pass # Replace with function body.


func spawn():
	var totalZombies = getEnemyAmount()
	for i in enemies.size():
		var enemy = enemies[i]
		if (enemy != null):
			for o in enemiesAmount[i]:
				totalZombies += 1
				if totalZombies > zombiCap:
					return
				var Zombi = load( enemies[i].get_path() )
				var zombi = Zombi.instance()
				get_parent().add_child(zombi)
				var randomness = Vector2(rand_range(-randomRange, randomRange), rand_range(-randomRange, randomRange))
				zombi.global_position = global_position + randomness

func getEnemyAmount():
	return get_tree().get_nodes_in_group("zombi").size()

func _on_Timer_timeout():
	if turnOnAllDied and getEnemyAmount() == 0:
		spawn()
#		if continuous:
#			timer.start()
	elif not turnOnAllDied:
		spawn()

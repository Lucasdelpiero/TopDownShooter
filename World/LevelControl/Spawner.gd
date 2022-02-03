extends Node2D

var Zombi = preload("res://Characters/zombi/zombi.tscn")

export var spawnFrenzy : bool = false
var zombiCap : int = 60
export var limitSpawnTimes: bool = false
export(int,1, 10) var roundsLimit = 1
var roundsSpawned : int = 0
export(String, "none","zombi", "zombiBig", "zombiFast", "zombiExplosive") var enemy0 = "none"
export(int,1, 50) var amount0 = 1 #Godot bug if not specified the default vallue
export(String, "none" ,"zombi", "zombiBig", "zombiFast", "zombiExplosive") var enemy1 = "none"
export(int,1, 50) var amount1 = 1
export(String,"none" ,"zombi", "zombiBig", "zombiFast", "zombiExplosive") var enemy2 = "none"
export(int,1, 50) var amount2 = 1

var zombiType = {
	"zombi" : preload("res://Characters/zombi/zombi.tscn"),
	"zombiBig" : preload("res://Characters/zombi/zombiBig.tscn"),
	"zombiFast" : preload("res://Characters/zombi/zombiFast.tscn"),
	"zombiExplosive" : preload("res://Characters/zombi/zombiExplosive.tscn"),
}

export(bool) var continuous = false
export(bool) var turnOnAllDied = false
export(bool) var autoStart = false
export(float, 1.0, 60.0, 1.0) var timerTime 

var enemies : Array 
var enemiesAmount : Array
var spawning : bool = false
var randomRange : float = 128.0

onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	yield(get_tree().create_timer(0.01), "timeout" )
	enemies = [enemy0, enemy1, enemy2]
	enemiesAmount = [amount0, amount1, amount2]
	
	timer.one_shot = not continuous

	if not turnOnAllDied:
		timer.wait_time = timerTime + 0.1
	if autoStart:
		timer.start()

func spawn():
	var totalZombies = getEnemyAmount()
	for i in enemies.size():
		var enemy = enemies[i]
		if (enemy != "none"):
			for o in enemiesAmount[i]:
				var delay = rand_range(0.1, 0.3)
				yield(get_tree().create_timer(delay),"timeout")
				totalZombies += 1
				if totalZombies > zombiCap:
					return
#				var Zombi = load( enemiesDir[enemies[i]] )
				var ZombiNew = zombiType[enemies[i]]
				var zombi = ZombiNew.instance()
				getSpawnDirection().call_deferred("add_child", zombi)
				var randomness = Vector2(rand_range(-randomRange, randomRange), rand_range(-randomRange, randomRange))
				zombi.global_position = global_position + randomness
				zombi.frenzy = spawnFrenzy
				zombi.unfreeze()

func getSpawnDirection(): 
	var temp = get_tree().get_root().find_node("Zombies", true, false)
	if (temp != null):
		return temp
	return get_parent()

func getEnemyAmount():
	return get_tree().get_nodes_in_group("zombi").size()

func _on_Timer_timeout():
	if turnOnAllDied and getEnemyAmount() == 0:
		activate()
#		spawn()
#		if continuous:
#			timer.start()
	elif not turnOnAllDied:
		activate()
#		spawn()

func activate():
	if limitSpawnTimes == false:
		spawn()
	else:
		if roundsSpawned < roundsLimit:
			spawn()
			roundsSpawned += 1
	if continuous:
		timer.start()

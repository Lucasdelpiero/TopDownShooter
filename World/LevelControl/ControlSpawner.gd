extends Node

var childrens : Array
onready var timer = $Timer
export(bool) var continuous = false
export(bool) var turnOnAllDied = false
export(bool) var autoStart = false
export(float, 1.0, 60.0, 1.0) var timerTime = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var nodes = get_children()
	for i in nodes.size():
		if nodes[i].is_in_group("spawn"):
			childrens.append(nodes[i])
	
	timer.one_shot = not continuous

	if not turnOnAllDied:
		timer.wait_time = timerTime
	if autoStart:
		timer.start()

func spawn(index):
	childrens[index].spawn()

func activate():
	for i in childrens.size():
		childrens[i].activate()

func _on_Timer_timeout():
	spawn(0)

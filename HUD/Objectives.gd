extends Control

# Win conditions
export var killAll = false
export var survive = false

export(float, 2.0, 60.0, 5.0) var timeSurvive = 2.0
#export(Array, bool) var enums 
#export(Array, int, "Red", "Green", "Blue") var enums = [2, 1, 0]
#export(int, FLAGS, "kill all", "survive", "k/w explosives", "k/w melee") var objectives = 0


var killAllCompleted = false
var surviveCompleted = false


var objectives = [ killAll, survive ]
var currentObjectives = [killAllCompleted, surviveCompleted]


var zombiesLeft = 0
var killedByExplosion = 0
var killedByMelee = 0

onready var label = $CanvasLayer/Base/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	zombiesLeft = get_tree().get_nodes_in_group("zombi").size()
	objectives = [ killAll, survive ]
	addObjectives()
	if survive:
		$TimerSurvive.start(timeSurvive)

func updateObjective(name, byMelee, byExplosion):
#	zombiesLeft =  get_tree().get_nodes_in_group("zombi").size()
	zombiesLeft -= 1
	checkCompletion()

func checkCompletion():
	if zombiesLeft < 1:
		killAllCompleted = true
	updateCompletion()
	for i in currentObjectives.size():
		if currentObjectives[i] == false:
			return #If any objective not completed it returns
	completed()

func updateCompletion():
	currentObjectives = [killAllCompleted, surviveCompleted]
	addObjectives()

func addObjectives():
	for i in objectives.size():
		if objectives[i] == false:
			currentObjectives.remove(i)
	print("objectives" + str(currentObjectives))

func completed():
	label.visible = true

func _on_TimerSurvive_timeout():
	surviveCompleted = true
	checkCompletion()

extends Control

# Required objectives
var allCompleted = false
export var finishAtCompletion = true #finish level when objectives are completed
export var killAll = false
export var survive = false
export(float, 2.0, 60.0, 5.0) var timeSurvive = 2.0

var objectivesDict = {
	kill = {
		"value" : "killZombies",
		"amount" : "totalKilled",
	},
	melee = {
		"value" : "withMelee",
		"amount" : "meleeAmount",
	} ,
	explosion = {
		"value" : "withExplosion",
		"amount" : "explosionAmount",
	},
}


# Optional objectives
export var withMelee = false
export(int, 1, 100, 1) var meleeAmount = 1
export var withExplosion = false
export(int, 1, 100, 1) var explosionAmount = 1
var killZombies = false # Kill certain amount

# Required completion
var killAllCompleted = false
var surviveCompleted = false

# Optional completion
var withMeleeCompleted = false
var withExplosionCompleted = false

# Lists
var objectives = [ killAll, survive ]
var currentObjectives = [killAllCompleted, surviveCompleted]

var optionalObjectives = [withMelee ,withExplosion]
var currentOptional = [withMeleeCompleted, withExplosionCompleted]

var listObjectives = []

# Count
var zombiesLeft = 0
var killedByExplosion = 0
var killedByMelee = 0
var totalKilled = 0

#Animation
var showing = true

onready var base = $CanvasLayer/Base
onready var label = $CanvasLayer/Base/Label
onready var lKillAll = $CanvasLayer/Base/VBC/OC2/HBC/LKillAll
onready var lSurvive = $CanvasLayer/Base/VBC/OC3/HBC/LSurvive
onready var lOptional = $CanvasLayer/Base/VBC/OC4/HBC/LOptional
onready var lMelee = $CanvasLayer/Base/VBC/OC5/HBC/LMelee
onready var lExplosion = $CanvasLayer/Base/VBC/OC6/HBC/LExplosion
onready var vBoxObjectives = $CanvasLayer/Base/VBC
onready var animationPlayer = $CanvasLayer/Base/AnimationPlayer

signal completedLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	zombiesLeft = get_tree().get_nodes_in_group("zombi").size()
	updateDict()
	# Updating the arrays with the changes made in editor
	objectives = [ killAll, survive ] 
	optionalObjectives = [withMelee ,withExplosion]
#	addObjectives() # bc if the tutorial
	
	shown(lKillAll, killAll)
	shown(lSurvive, survive) 
	shown(lMelee, withMelee) 
	shown(lExplosion, withExplosion)  
	shown(lOptional, withExplosion or withMelee)
	
	#Create List
	var list = vBoxObjectives.get_children() 
	for i in list.size():
		if list[i] is Label:
			listObjectives.append(list[i]) 
	
	if survive:
		$TimerSurvive.start(timeSurvive)
		lSurvive.text = "Survive for %s seconds" % str(timeSurvive)

	if withMelee:
		lMelee.text = "Kill %s zombies in melee" % str(meleeAmount)

	if withExplosion:
		lExplosion.text = "Kill %s zombies with an explosion" % str(explosionAmount)

	yield(get_tree().create_timer(0.1),"timeout")
	var scoring = get_tree().get_root().find_node("Scoring", true, false)
# warning-ignore:return_value_discarded
	connect("completedLevel", scoring, "statsResult")

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
#		base.set_visible(not base.is_visible())
		if showing:
			animationPlayer.play("Hide")
			showing = false
		else:
			animationPlayer.play("Show")
			showing = true


##########################################################################################################

func updateObjective(_name, byMelee, byExplosion, _pos):
	
	if byMelee:
		killedByMelee += 1
	if byExplosion:
		killedByExplosion += 1
	
	totalKilled += 1
	yield(get_tree().create_timer(1.0), "timeout")
	checkCompletion()

func checkCompletion(): 
	zombiesLeft =  get_tree().get_nodes_in_group("zombi").size()
	
	if zombiesLeft < 1:
		killAllCompleted = true
	
	# Optionals Objectives
	if withMelee:
		if killedByMelee >= meleeAmount:
			withMeleeCompleted = true
	if withExplosion:
		if killedByExplosion >= explosionAmount:
			withExplosionCompleted = true
	
	updateCompletion()
	checkOptional()

	for i in currentObjectives.size():
		if currentObjectives[i] == false:
			return #If any objective not completed it return
	for i in optionalObjectives.size():
		if optionalObjectives[i] == false:
			if i < currentOptional.size(): # Fix bug with i out of range if no current optional objective
				currentOptional.remove(i)
	completed() # Win

func checkOptional():
	for i in currentOptional.size():
		if currentOptional[i] == false:
			return
			
	print("OPTIONALS COMPLETED")

func updateCompletion(): # Update content of arrays
	currentObjectives = [killAllCompleted, surviveCompleted]
	currentOptional = [withMeleeCompleted, withExplosionCompleted]
	addObjectives()

func addObjectives(): # Keep only active objectives
	for i in objectives.size():
		var o = objectives.size() - 1 - i
		if objectives[o] == false:
			currentObjectives.remove(o)
	
	for i in optionalObjectives.size():
		var o = optionalObjectives.size() - 1 - i
		if optionalObjectives[o] == false:
			currentOptional.remove(o)
			
#	print("objectives" + str(currentOptional))

func newObjectives(aCondition, aConditionAmount): # Add new objectives to the list
#	print("RECIBIDO")
	print("Condition: " + aCondition)
#	print("Amount: " + str(aConditionAmount))
	
#	var value = objectivesDict[aCondition]["value"]
#	print(value)
#	optionalObjectives.append()
	var value = str(objectivesDict[aCondition]["value"])
	var amountObjective = str(objectivesDict[aCondition]["amount"])
	print("value: " + str(value))
	print("amount: " +str(amountObjective))
	self.set(value, true)
	self.set(amountObjective, aConditionAmount)
#	currentOptional.append(objectivesDict[aCondition]["value"])
	print("with exp: " +str(withExplosion))
	print("with melee: " +str(withMelee))
	print("optionals: " + str(optionalObjectives))
	updateDict()
	
	######pa borrar
	pass
	
var objectivesDictss = {
	kill = {
		"value" : killZombies,
		"amount" : totalKilled,
	},
}


func completed():
	if not allCompleted and finishAtCompletion:
		label.visible = true
		emit_signal("completedLevel")
		allCompleted = true

func _on_TimerSurvive_timeout():
	surviveCompleted = true
	checkCompletion()

func shown(node, value : bool):
	node.get_parent().get_parent().visible = value

func updateDict():
	optionalObjectives = [withMelee ,withExplosion]
	shown(lKillAll, killAll)
	shown(lSurvive, survive) 
	shown(lMelee, withMelee) 
	shown(lExplosion, withExplosion)  
	shown(lOptional, withExplosion or withMelee)
	if survive:
		$TimerSurvive.start(timeSurvive)
		lSurvive.text = "Survive for %s seconds" % str(timeSurvive)

	if withMelee:
		lMelee.text = "Kill %s zombies in melee" % str(meleeAmount)

	if withExplosion:
		lExplosion.text = "Kill %s zombies with an explosion" % str(explosionAmount)

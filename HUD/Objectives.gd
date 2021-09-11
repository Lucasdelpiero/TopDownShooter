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
		"amount" : "killAmount",
		"tracker" : "totalKilled",
		"completion" : "killedAmountCompleted"
	},
	melee = {
		"value" : "withMelee",
		"amount" : "meleeAmount",
		"tracker" : "killedByMelee",
		"completion" : "withMeleeCompleted"
	} ,
	explosion = {
		"value" : "withExplosion",
		"amount" : "explosionAmount",
		"tracker" : "killedByExplosion",
		"completion" : "withExplosionCompleted"
	},
}

# Optional objectives
export var withMelee = false
export(int, 1, 100, 1) var meleeAmount = 1
export var withExplosion = false
export(int, 1, 100, 1) var explosionAmount = 1
var killZombies = false # Kill certain amount
export(int, 1, 100, 1) var killAmount = 1

# Required completion
var killAllCompleted = false
var surviveCompleted = false

# Optional completion
var withMeleeCompleted = false
var withExplosionCompleted = false

# Lists
var objectives = [ killAll, survive ]
var currentObjectives = [killAllCompleted, surviveCompleted]

#var optionalObjectives = [withMelee ,withExplosion]
var optionalObjectives = ["melee" ,"explosion"]
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
onready var tween = $CanvasLayer/Base/Tween

var posShown = Vector2(0.0, 0.0)
var posHidden = Vector2(400.0, 0.0) ## Check if works in different resolutions
var animationTime = 1.0

signal completedLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	zombiesLeft = get_tree().get_nodes_in_group("zombi").size()
	updateDict()
	# Updating the arrays with the changes made in editor
	objectives = [ killAll, survive ] 
	optionalObjectives = [withMelee ,withExplosion]
#	addObjectives() # bc if the tutorial
	
	updateLabels()
	#Create List
	var list = vBoxObjectives.get_children() 
	for i in list.size():
		if list[i] is Label:
			listObjectives.append(list[i]) 
	
	yield(get_tree().create_timer(0.1),"timeout")
	var scoring = get_tree().get_root().find_node("Scoring", true, false)
# warning-ignore:return_value_discarded
	connect("completedLevel", scoring, "statsResult")

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
#		base.set_visible(not base.is_visible())
		if showing:
			tween.interpolate_property(base, "rect_position", posShown, posHidden, animationTime, Tween.TRANS_CUBIC, Tween.EASE_OUT )
			tween.start()
			showing = false
		else:
			tween.interpolate_property(base, "rect_position", posHidden, posShown, animationTime, Tween.TRANS_QUINT, Tween.EASE_OUT )
			tween.start()
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
	
	checkOptional()
	updateCompletion()
	
	for i in currentObjectives.size():
		if currentObjectives[i] == false:
			return #If any objective not completed it return
	for i in optionalObjectives.size():
		if optionalObjectives[i] == false:
			if i < currentOptional.size(): # Fix bug with i out of range if no current optional objective
				currentOptional.remove(i)
	completed() # Win
	

func checkOptional():
	var array = objectivesDict.keys()
	
	for i in array.size(): #If the amount needed is reached its completed
		if get( objectivesDict[array[i]]["value"] ) == true:
			var objective = array[i]
			var current = get( objectivesDict[objective]["tracker"] )
			var needed = get( objectivesDict[objective]["amount"] )
			var completed = str( objectivesDict[objective]["completion"] )
			if current >= needed:
				if get(completed) == false:
					completedObjective(objective)
	
	for i in array.size():
		if get( objectivesDict[array[i]]["value"] ) == true:
			if get( objectivesDict[array[i]]["completion"] ) == false:
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
	var value = str(objectivesDict[aCondition]["value"])
	var amountObjective = str(objectivesDict[aCondition]["amount"])
	var completion = str(objectivesDict[aCondition]["completion"])
	
	self.set(value, true)
	self.set(amountObjective, aConditionAmount)
	self.set(completion, false)
	updateDict()
	updateLabels()

func completedObjective(aObjective):
	var value = str(objectivesDict[aObjective]["value"])
	set(value, true)
	#Placeholder for animation
	deleteObjectives(aObjective)

func deleteObjectives(aObjective):
	var value = str(objectivesDict[aObjective]["value"])
	self.set(value, false)
	updateDict()
	updateLabels()

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
#	optionalObjectives = [withMelee ,withExplosion]
#	optionalObjectives = [get(objectivesDict[["melee"] )]
	getDictValues()
	pass

func getDictValues():
	var keys = objectivesDict.keys()
	var array = []
	for i in keys.size():
		array.append( get(objectivesDict[keys[i]]["value"]) )
#		print(keys[i]+ ": " + str(array[i]))

func updateLabels():
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

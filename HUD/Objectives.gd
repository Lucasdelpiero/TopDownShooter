extends Control

# Fix bug with time
# Required objectives
var allCompleted = false
export var finishAtCompletion = true #finish level when objectives are completed
export var killAll = false
export var survive = false
export var hasToReachFinish = false
export(float, 2.0, 60.0, 5.0) var timeSurvive = 2.0

# Required completion
var killAllCompleted = false
var surviveCompleted = false

var objectivesMain = {
	killAll = {
		"value" : "killAll",
		"completion" : "killAllCompleted",
	},
	survive = {
		"value" : "survive",
		"completion" : "surviveCompleted",
	}
	
}

# Optional objectives
export var withMelee = false
export(int, 1, 100, 1) var meleeAmount = 1
export var withExplosion = false
export(int, 1, 100, 1) var explosionAmount = 1
var killZombies = false # Kill certain amount
export(int, 1, 100, 1) var killAmount = 1
## Tutorial
var inTutorial = false
var optionalText = "Bonus objective:"

# Optional completion
var withMeleeCompleted = false
var withExplosionCompleted = false

var objectivesOpt = {
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
onready var lKillAll = $CanvasLayer/Base/VBC/OC2/MarginContainer/LKillAll
onready var lSurvive = $CanvasLayer/Base/VBC/OC3/MarginContainer/LSurvive
onready var lObjectives = $CanvasLayer/Base/VBC/OC/MarginContainer/LObjectives
onready var lObjectives_key = $CanvasLayer/Base/VBC/OC/MarginContainer/LObjectives.text
onready var lOptional = $CanvasLayer/Base/VBC/OC3/MarginContainer/LSurvive
onready var lMelee = $CanvasLayer/Base/VBC/OC3/MarginContainer/LSurvive
onready var lExplosion = $CanvasLayer/Base/VBC/OC3/MarginContainer/LSurvive
onready var lReachFinish = $CanvasLayer/Base/VBC/OC3/MarginContainer/LSurvive
onready var vBoxObjectives = $CanvasLayer/Base/VBC
onready var tween = $CanvasLayer/Base/Tween
onready var autoHideTimer = $AutoHide

var posShown = Vector2(0.0, 0.0)
var posHidden = Vector2(400.0, 0.0) ## Check if works in different resolutions
var animationTime = 1.0

signal completedLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerSurvive.start(timeSurvive)
	zombiesLeft = get_tree().get_nodes_in_group("zombi").size()
	updateDict()
	# Updating the arrays with the changes made in editor
	objectives = [ killAll, survive ] 
	optionalObjectives = [withMelee ,withExplosion]
	addObjectives() # bc if the tutorial
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
		objectives_visible(!showing) # show or hide objectives 

##########################################################################################################

func objectives_visible(isVisible):
	if (!isVisible):
		if (showing):
			tween.interpolate_property(base, "rect_position", base.rect_position, posHidden, animationTime, Tween.TRANS_CUBIC, Tween.EASE_OUT )
			tween.start()
			showing = false
	else:
		tween.interpolate_property(base, "rect_position", base.rect_position, posShown, animationTime, Tween.TRANS_QUINT, Tween.EASE_OUT )
		tween.start()
		showing = true

func updateObjective(_name, byMelee, byExplosion, _pos):
	
	if byMelee:
		killedByMelee += 1
	if byExplosion:
		killedByExplosion += 1
	
	totalKilled += 1
	updateLabels()
	checkCompletion()
	

func checkCompletion(): 
	yield(get_tree().create_timer(0.1),"timeout")
	zombiesLeft =  get_tree().get_nodes_in_group("zombi").size()
	
	if zombiesLeft < 1:
		killAllCompleted = true
	
	checkObjectives(objectivesMain)
	checkObjectives(objectivesOpt)
#	updateCompletion()

func checkObjectives(dict : Dictionary):
	var array = dict.keys()
	var complete = true
	
	for i in array.size(): #If the amount needed is reached its completed
		if get( dict[array[i]]["value"]) == true:
			var objective = dict[array[i]] # Ex. survive, kill 5
			var completed = str( objective["completion"] )
			
			if dict[array[i]].has("tracker") and dict[array[i]].has("amount"):
				var current = get( objective["tracker"] )
				var needed = get( objective["amount"] )
				if current >= needed:
					if get(completed) == false:
						completedObjective(objective) # Only secondaries by now
			else:
				if get( objective["completion"] ):
					completedObjective(objective)
				elif get( objective["completion"] ) == false :
					complete = false
	
	if array.has("survive") and complete: # If all main objectives needed are completed this completes the game
		completed()

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
	if aCondition != "none":
		var value = str(objectivesOpt[aCondition]["value"])
		var amountObjective = str(objectivesOpt[aCondition]["amount"])
		var completion = str(objectivesOpt[aCondition]["completion"])
		
		self.set(value, true)
		self.set(amountObjective, aConditionAmount)
		self.set(completion, false)
	updateDict()
	updateLabels()

func completedObjective(aObjective):
#	var value = str(objectivesOpt[aObjective]["value"])
	var value = str(aObjective["value"])
	set(value, true)
	#Placeholder for animation
	deleteObjectives(aObjective)

func deleteObjectives(aObjective):
#	var value = str(objectivesOpt[aObjective]["value"])
	var value = str(aObjective["value"])
	self.set(value, false)
	updateDict()
	updateLabels()

func completed():
	if not allCompleted and finishAtCompletion:
		label.visible = true
		finishLevel()
		allCompleted = true

func finishLevel():
	emit_signal("completedLevel")

func _on_TimerSurvive_timeout():
	surviveCompleted = true
	checkCompletion()

func shown(node, value : bool):
	node.get_parent().visible = value

func updateDict():
#	optionalObjectives = [withMelee ,withExplosion]
#	optionalObjectives = [get(objectivesOpt[["melee"] )]
	getDictValues()
	pass

func getDictValues():
	var keys = objectivesOpt.keys()
	var array = []
	for i in keys.size():
		array.append( get(objectivesOpt[keys[i]]["value"]) )
#		print(keys[i]+ ": " + str(array[i]))

func updateLabels():
	shown(lKillAll, killAll)
	shown(lSurvive, survive) 
	shown(lMelee, withMelee) 
	shown(lExplosion, withExplosion)  
	shown(lOptional, withExplosion or withMelee)
	shown(lReachFinish, hasToReachFinish)
	
	lObjectives.text = tr(lObjectives_key)
	
	if survive:
		# Create label Class that automaticly padd for the sides 
		lSurvive.text = tr("SURVIVE_X_SECONDS") % str(timeSurvive)

	if withMelee:
		lMelee.text = tr("KILL_IN_MELEE")  % [ str(meleeAmount), str(killedByMelee), meleeAmount ] + "    "

	if withExplosion:
		lExplosion.text = tr("KILL_WITH_EXPLOSION") % [ str(explosionAmount), str(killedByExplosion), explosionAmount ]

func activateTutorial(): #Set optional label to tutorial related
	$CanvasLayer/Base/VBC/OC4/MarginContainer/LOptional.text = "Tutorial:"

func updateText():
	updateLabels()


func _on_AutoHide_timeout():
	objectives_visible(false)

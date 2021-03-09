extends Control

# Required objectives
export var killAll = false
export var survive = false
export(float, 2.0, 60.0, 5.0) var timeSurvive = 2.0

# Optional objectives
export var withMelee = false
export(int, 1, 100, 1) var meleeAmount = 1
export var withExplosion = false
export(int, 1, 100, 1) var explosionAmount = 1

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

onready var base = $CanvasLayer/Base
onready var label = $CanvasLayer/Base/Label
onready var lKillAll = $CanvasLayer/Base/VBoxContainer/LKillAll
onready var lSurvive = $CanvasLayer/Base/VBoxContainer/LSurvive
onready var lOptional = $CanvasLayer/Base/VBoxContainer/LOptional
onready var lMelee = $CanvasLayer/Base/VBoxContainer/LMelee
onready var lExplosion = $CanvasLayer/Base/VBoxContainer/LExplosion
onready var vBoxObjectives = $CanvasLayer/Base/VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	zombiesLeft = get_tree().get_nodes_in_group("zombi").size()
	# Updating the arrays with the changes made in editor
	objectives = [ killAll, survive ] 
	optionalObjectives = [withMelee ,withExplosion]
	addObjectives()
	
	lKillAll.visible = killAll
	lSurvive.visible = survive
	lMelee.visible = withMelee
	lExplosion.visible = withExplosion
	lOptional.visible = (withExplosion or withMelee)
	
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

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		base.set_visible(not base.is_visible())

##########################################################################################################

func updateObjective(name, byMelee, byExplosion):
#	zombiesLeft =  get_tree().get_nodes_in_group("zombi").size()
	zombiesLeft -= 1
	if byMelee:
		killedByMelee += 1
	if byExplosion:
		killedByExplosion += 1
	
#	print("Melee " +str(byMelee))
#	print("Explosion " +str(byExplosion))
	checkCompletion()

func checkCompletion(): 
	
	if zombiesLeft < 1:
		killAllCompleted = true
	if withMelee:
		if killedByMelee == meleeAmount:
			withMeleeCompleted = true
	if withExplosion:
		if killedByExplosion == explosionAmount:
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
		if objectives[i] == false:
			currentObjectives.remove(i)
	
	for i in optionalObjectives.size():
		if optionalObjectives[i] == false:
			currentOptional.remove(i)
#	print("objectives" + str(currentOptional))

func completed():
	label.visible = true

func _on_TimerSurvive_timeout():
	surviveCompleted = true
	checkCompletion()

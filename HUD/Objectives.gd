extends Control

# Required objectives
var allCompleted = false
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
	# Updating the arrays with the changes made in editor
	objectives = [ killAll, survive ] 
	optionalObjectives = [withMelee ,withExplosion]
	addObjectives()
	
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

func updateObjective(_name, byMelee, byExplosion):
	zombiesLeft =  get_tree().get_nodes_in_group("zombi").size()
	zombiesLeft -= 1
	if byMelee:
		killedByMelee += 1
	if byExplosion:
		killedByExplosion += 1
	checkCompletion()

func checkCompletion(): 
	
	if zombiesLeft < 1:
		killAllCompleted = true
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

func completed():
	if not allCompleted:
		label.visible = true
		emit_signal("completedLevel")
		allCompleted = true

func _on_TimerSurvive_timeout():
	surviveCompleted = true
	checkCompletion()

func shown(node, value : bool):
	node.get_parent().get_parent().visible = value


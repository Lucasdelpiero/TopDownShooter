extends Control

onready var totalScoreL = $Panel/VBoxContainer/TotalScore
export(NodePath) var totalScoreP
var totalScoreCounter 
onready var totalScoreKey = totalScoreL.text
var totalScore = 0
var totalScoreTw = 0 # Value to be tweened from 0 to the real value

onready var maxComboL = $Panel/VBoxContainer/MaxCombo
export(NodePath) var maxComboP 
var maxComboCounter 
onready var maxComboKey = maxComboL.text
var maxCombo = 0
var maxComboTw = 0

onready var timeL = $Panel/VBoxContainer/Time
export(NodePath) var timeP
var timeCounter 
onready var timeKey = timeL.text
var time = 0
var timeTw = 0

onready var totalKilledL = $Panel/VBoxContainer/TotalKilled
export(NodePath) var totalKilledP
var totalKilledCounter 
onready var totalKilledKey = totalKilledL.text
var totalKilled = 0
var totalKilledTw = 0

onready var totalMeleeL = $Panel/VBoxContainer/TotalMelee
export(NodePath) var totalMeleeCounter
onready var totalMeleeKey = totalMeleeL.text
var totalMelee = 0
var totalMeleeTw = 0
onready var totalExplosionL = $Panel/VBoxContainer/TotalExposion
export(NodePath) var totalExplosionCounter
onready var totalExplosionKey = totalExplosionL.text
var totalExplosion = 0
var totalExplosionTw = 0
onready var tween = $Tween
export(float, 0.1, 5.0, 0.1) var countDuration = 1.5

onready var timer = $Timer

var labels := []
var keys := []
var counters := []

var scoresList = [
	"totalScore",
	"maxCombo",
	"time",
	"totalKilled",
	"totalMelee",
	"totalExplosion",
]

var lastInt = [ 0, 0, 0, 0, 0, 0,]

var Sfx = preload("res://HUD/Sounds/Sfx.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true 
	GlobalControl.showMouse(true) 
	var options = get_tree().get_root().find_node("Options", true, false)
	options.pausable = false
	labels = get_tree().get_nodes_in_group("stats_label")
	counters = get_tree().get_nodes_in_group("counter_label")
	for i in labels:
		keys.append(i.text)
#	addScoresToDict()

	yield(get_tree().create_timer(0.1), "timeout")
	for i in scoresList.size():
		updateScore(scoresList[i], i) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in lastInt.size():
		updateSound(i)
	updateLabels()
	if Input.is_action_just_pressed("ui_accept"):
		skipAnimation()
#	print(totalScoreTw)


func updateScore(property, _delay):
#	tween.interpolate_property(self , property + "Tw" , 0 , get(property), countDuration  , Tween.TRANS_LINEAR, Tween.TRANS_LINEAR, countDuration * delay)
	tween.interpolate_property(self , property + "Tw" , 0 , get(property), countDuration  , Tween.TRANS_LINEAR, Tween.TRANS_LINEAR, 0)
	tween.start()

func updateLabels():
#	totalScoreL.text = "%s: %d" % [tr(totalScoreKey), totalScoreTw]
#	maxComboL.text = "%s: %d" % [tr(maxComboKey), maxComboTw]
#	timeL.text = "%s: %d" % [tr(timeKey), timeTw]
#	totalKilledL.text = "%s: %d" % [tr(totalKilledKey), totalKilledTw]
#	totalMeleeL.text = "%s: %d" % [tr(totalMeleeKey) , totalMeleeTw]
#	totalExplosionL.text = "%s: %d" % [tr(totalExplosionKey), totalExplosionTw]
	for i in labels.size():
		labels[i].text = "%s:" % tr(keys[i])
		
		var baseName = nameToVar(counters[i].name)
		counters[i].text = str(int(get(baseName + "Tw")))
#		counters[i].text = self.get(baseName + "Tw")
#		print(counters[i].name)
#		counters[i].text = self.get(counters[i].name + "Tw")
	pass

# Converts the name of the node to the base of the variables, which are 
# in lower case in the first letter
func nameToVar(arg):
	var firstLetter = arg[0].to_lower()
	var oldName = arg
	oldName.erase(0,1)
	var newWord = firstLetter + oldName
	return newWord

func updateLabelsLarge():
	totalScoreL.text = "%s :" % tr(totalScoreKey)
	totalScoreCounter.text = str(totalScoreTw)
	maxComboL.text = "%s :" % tr(maxComboKey)
	maxComboCounter.text = maxComboTw
	timeL.text = "%s: " % tr(timeKey)
	timeCounter.text = timeTw
	totalKilledL.text = "%s:" % tr(totalKilledKey)
	totalKilledCounter.text = totalKilledTw
	totalMeleeL.text = "%s:" % tr(totalMeleeKey)
	totalMeleeCounter.text = totalMeleeTw
	totalExplosionL.text = "%s:" % tr(totalExplosionKey)
	totalExplosionCounter.text = totalExplosionTw


func skipAnimation():
	tween.stop_all()
	for i in scoresList.size():
		set( scoresList[i] + "Tw", get(scoresList[i]) ) 

func soundPoints():
	var sfx = Sfx.instance()
	add_child(sfx)
	sfx.play("points")


var canPLaySound = false
func updateSound(value):
	if lastInt[value] != int( get(scoresList[value] + "Tw" ) ):
		lastInt[value] = int( get(scoresList[value] + "Tw" ) )
		
		if canPLaySound:
			canPLaySound = false
			soundPoints()
			timer.start()


func _on_Timer_timeout():
	canPLaySound = true
#	queue_free()
	pass

func _on_ContinueButton_pressed():
	get_tree().paused = false
	GlobalControl.showMouse(true)
	GlobalControl.levelSelected += 1
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")
	pass 




func _on_NextLevelButton_pressed():
	GlobalControl.goto_next_level()


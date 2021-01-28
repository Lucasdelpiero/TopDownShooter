extends Control

var totalScore = 0         # Total Score
var individualScore = 0    # Last action score
var comboScore = 0         # Total individual score in the combo
var multiplicator = 0      # Multiplicator to all kill in the combo
var comboBarValue = 50
export var comboTime = 2

onready var comboLabel = $ComboLabels/Score
onready var multiplicatorLabel = $ComboLabels/Multiplicator
onready var totalLabel = $TotalScoreLabel
onready var comboBar = $ComboLabels/ComboBar
onready var tweenComboBar = $ComboLabels/ComboBar/Tween

var dictionary = {
	"zombi" : 200,
	"zombiBig" : 1000,
	"zombiFast" : 400,
	"zombiExplosive" : 250,
#	"physics_process" : 200
}


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	startCombo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if timerCombo.is_stopped():
#		timerCombo.start()
	pass

func updateScore(name):
	var base = dictionary[name]
	individualScore = base
	comboScore += base
	multiplicator += 1
	totalScore += 5000
	
	updateLabels()
	
	resetCombo()

	

func startCombo():
	tweenComboBar.interpolate_property(comboBar, "value", 100, 0, comboTime, Tween.TRANS_LINEAR)
	tweenComboBar.start()
	changeVisibility(true)

func resetCombo():
	tweenComboBar.interpolate_property(comboBar, "value", 0, 100, 0, Tween.TRANS_LINEAR)
	tweenComboBar.start()
	startCombo()

func endCombo():
	comboScore = 0
	multiplicator = 0
	updateLabels()
	changeVisibility(false)
	#add total score obtained in the combo

func _on_Tween_tween_all_completed():
	if comboBar.value == 0:
		endCombo()

func updateLabels():
	comboLabel.text = str(comboScore)
	multiplicatorLabel.text = " x " + str(multiplicator)
	totalLabel.text = str(totalScore)

func changeVisibility(value):
	comboBar.visible = value
	comboLabel.visible = value
	multiplicatorLabel.visible = value



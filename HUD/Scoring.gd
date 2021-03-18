extends Control

var totalScore = 0         # Total Score
var individualScore = 0    # Last action score
var comboScore = 0         # Total individual score in the combo
var multiplicator = 0      # Multiplicator to all kill in the combo
var comboBarValue = 50
export var comboTime = 2.5
var killedByMelee = 2
var killedByExplosion = 2

var initialAlpha = Color(1.0, 1.0, 1.0, 1.0)
var fadedAlpha = Color(1.0, 1.0, 1.0, 0.0)

onready var comboLabel = $ComboLabels/Score
onready var multiplicatorLabel = $ComboLabels/Multiplicator
onready var totalLabel = $TotalScoreLabel
onready var comboBar = $ComboLabels/ComboBar
onready var tweenComboBar = $ComboLabels/ComboBar/Tween
onready var lastCombo = $ComboLabels/LastCombo
onready var tweenLastCombo = $ComboLabels/LastCombo/Tween
var optionsControl 

var dictionary = {
	"zombi" : 20,
	"zombiBig" : 100,
	"zombiFast" : 40,
	"zombiExplosive" : 25,
}
signal updateMusic(value)
func _on_Scoring_tree_entered():
	yield(get_tree().create_timer(0.01), "timeout")
#	startCombo()

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(1), "timeout")
	optionsControl = get_tree().get_root().find_node("Options", true, false)
	connect("updateMusic", optionsControl, "activateMusic")

func updateScore(name, byMelee, byExplosion):
	var base = dictionary[name] 
	individualScore = base + base * int(byMelee) * killedByMelee + base * int(byExplosion) * killedByExplosion
	comboScore += individualScore
	multiplicator += 1
	
	updateLabels()
	
	resetCombo()

	

func startCombo():
	tweenComboBar.interpolate_property(comboBar, "value", 100, 0, comboTime,Tween.TRANS_SINE, Tween.EASE_OUT)
	tweenComboBar.start()
	changeVisibility(true)
	emit_signal("updateMusic", true)

func resetCombo():
	tweenComboBar.interpolate_property(comboBar, "value", 0, 100, 0, Tween.TRANS_LINEAR)
	tweenComboBar.start()
	startCombo()

func endCombo():
	lastCombo.text = str(comboScore * multiplicator)
	totalScore += comboScore * multiplicator
	unFadeLastCombo()
	fadeLastCombo()
	
	comboScore = 0
	multiplicator = 0
	updateLabels()
	changeVisibility(false)
	#add total score obtained in the combo

func _on_Tween_tween_all_completed():
	if comboBar.value == 0:
		endCombo()
		fadeMusic()

func updateLabels():
	comboLabel.text = str(comboScore)
	multiplicatorLabel.text = " x " + str(multiplicator)
	totalLabel.text = str(totalScore)

func changeVisibility(value):
	comboBar.visible = value
	comboLabel.visible = value
	multiplicatorLabel.visible = value

func fadeLastCombo():
	tweenLastCombo.interpolate_property(lastCombo, "modulate", initialAlpha, fadedAlpha, 1, Tween.TRANS_LINEAR,Tween.EASE_IN, 2)
	tweenLastCombo.start()

func unFadeLastCombo():
	tweenLastCombo.interpolate_property(lastCombo, "modulate", fadedAlpha, initialAlpha, 0, Tween.TRANS_LINEAR)
	tweenLastCombo.start()

func fadeMusic():
	emit_signal("updateMusic", false)





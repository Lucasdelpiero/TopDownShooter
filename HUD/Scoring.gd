extends Control

var totalScore = 0         # Total Score
var individualScore = 0    # Last action score
var comboScore = 0         # Total individual score in the combo
var multiplicator = 0      # Multiplicator to all kill in the combo
var comboBarValue = 50
export var comboTime = 2.5
var killedByMelee = 2
var killedByExplosion = 2

export(float, 0.1, 3.0, 0.1) var timeStats = 1.0 #Time to show the stats panel

var initialAlpha = Color(1.0, 1.0, 1.0, 1.0)
var fadedAlpha = Color(1.0, 1.0, 1.0, 0.0)

onready var ScoreBubble = preload("res://Effects/ScoreBubble.tscn")

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

#STATS
onready var Stats = preload("res://HUD/Stats.tscn")
onready var timeLabel = $TimeLabel
var timeNow = 0
var maxCombo = 0
var totalKilled = 0
var totalMelee = 0
var totalExplosion = 0 
var levelName = "none"

signal updateMusic(value)
func _on_Scoring_tree_entered():
	yield(get_tree().create_timer(0.01), "timeout")
#	startCombo()

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(1), "timeout")
	optionsControl = get_tree().get_root().find_node("Options", true, false)
# warning-ignore:return_value_discarded
	connect("updateMusic", optionsControl, "activateMusic")

func _process(_delta):
#	get_time()
	pass

func updateScore(name, byMelee, byExplosion, pos):
	var base = dictionary[name] 
	individualScore = base + base * int(byMelee) * killedByMelee + base * int(byExplosion) * killedByExplosion
	comboScore += individualScore
	multiplicator += 1
	
	totalKilled += 1
	totalMelee += int(byMelee)
	totalExplosion += int(byExplosion)
	
	var scoreBubble = ScoreBubble.instance()
	get_parent().get_parent().add_child(scoreBubble)
	scoreBubble.global_position = pos
	scoreBubble.text = "50000"
	
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
	
	if multiplicator > maxCombo:
		maxCombo = multiplicator
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

func _on_Timer_timeout():
	timeNow += 1
	var minutes = timeNow / 60
	var seconds = timeNow % 60 # lo que sobra de los minutos
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	timeLabel.text = str_elapsed 
#	print("by melee: " + str(totalMelee))
#	print("by explosion: " + str(totalExplosion))

func statsResult():
	var time = timeNow #To fix the time delay
	yield(get_tree().create_timer(timeStats), "timeout")
	
	endCombo()
	sendResults( levelName )
	
	var stats = Stats.instance()
	add_child(stats)
	stats.totalScore = totalScore
	stats.totalKilled = totalKilled
	stats.time = time
	stats.maxCombo = maxCombo
	stats.totalMelee = totalMelee
	stats.totalExplosion = totalExplosion

func sendResults(aName):
	var results = {
		"name" : aName,
		"score" : totalScore,
		"maxCombo" : maxCombo,
		"time" : timeNow,
		"totalKilled" : totalKilled,
		"totalMelee" : totalMelee,
		"totalExplosion" : totalExplosion,
	}
	
	GlobalControl.update_max_score(results)
#	get_tree().change_scene("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")
	

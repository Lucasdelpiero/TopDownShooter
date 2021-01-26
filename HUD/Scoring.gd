extends Control

var totalScore = 0         # Total Score
var individualScore = 0    # Last action score
var comboScore = 0         # Total individual score in the combo
var multiplicator = 0      # Multiplicator to all kill in the combo

onready var comboLabel = $ComboLabels/Score
onready var multiplicatorLabel = $ComboLabels/Multiplicator
onready var totalLabel = $TotalScoreLabel

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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	totalLabel.text = str(dictionary["zombi"])
	pass

func updateScore(name):
	var base = dictionary[name]
	individualScore = base
	comboScore += base
	multiplicator += 1
	totalScore += 5000
	comboLabel.text = str(comboScore)
	multiplicatorLabel.text = " x " + str(multiplicator)
	totalLabel.text = str(totalScore)
	

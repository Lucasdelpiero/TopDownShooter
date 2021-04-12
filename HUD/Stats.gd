extends Control

onready var totalScore = $Panel/VBoxContainer/TotalScore
onready var maxCombo = $Panel/VBoxContainer/MaxCombo
onready var time = $Panel/VBoxContainer/Time
onready var totalKilled = $Panel/VBoxContainer/TotalKilled
onready var totalMelee = $Panel/VBoxContainer/TotalMelee
onready var totalExplosion = $Panel/VBoxContainer/TotalExposion




# Called when the node enters the scene tree for the first time.
func _ready():
#	totalScoreL.text = str(totalScore)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()

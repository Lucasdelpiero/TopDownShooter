extends Control

onready var totalScore = $Panel/VBoxContainer/TotalScore
onready var maxCombo = $Panel/VBoxContainer/MaxCombo
onready var time = $Panel/VBoxContainer/Time
onready var totalKilled = $Panel/VBoxContainer/TotalKilled
onready var totalMelee = $Panel/VBoxContainer/TotalMelee
onready var totalExplosion = $Panel/VBoxContainer/TotalExposion




# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
#	totalScoreL.text = str(totalScore)
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
#	queue_free()
	pass




func _on_ContinueButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")
	pass 

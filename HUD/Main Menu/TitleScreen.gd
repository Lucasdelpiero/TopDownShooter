extends Control

onready var options = $OptionsLayer/Options 
onready var transition = $Transition/AnimationPlayer
var levelSelector = load("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")

func _on_StartButton_pressed():
	transition.play("Fade Out")
	yield(transition, "animation_finished")
	get_tree().change_scene_to(levelSelector)
func _on_ExitButton_pressed():
	get_tree().quit()

func _on_OptionsButton_pressed():
	options.visible = true

func play_unfade():
	transition.play("Fade Out")

func play_fade():
	transition.play("Show Title")


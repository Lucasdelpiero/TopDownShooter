extends Control

onready var options = $OptionsLayer/Options 
onready var transition = $Transition/AnimationPlayer

func _on_StartButton_pressed():
	transition.play("Fade In")
#	yield(get_tree().create_timer(0.5), "timeout")
	yield(transition, "animation_finished")
	get_tree().change_scene("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_OptionsButton_pressed():
	options.visible = true

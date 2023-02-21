extends Control

var mainMenu = preload("res://HUD/Main Menu/TitleScreen.tscn")
onready var transition = $Transition/AnimationPlayer

func _on_BtnEnglish_pressed():
	TranslationServer.set_locale("en")
	play_transition()

func _on_BtnSpanish_pressed():
	TranslationServer.set_locale("es")
	play_transition()

func play_transition():
	transition.play("Fade In")
	yield(transition, "animation_finished")
	get_tree().change_scene_to(mainMenu)

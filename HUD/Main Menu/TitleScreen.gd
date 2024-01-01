extends Control

onready var options = $OptionsLayer/Options 
onready var transition = $Transition/AnimationPlayer
onready var language_selector = $LanguageSelector
onready var vbox_menu = $VBoxContainer
var levelSelector = load("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")
var first_level = load("res://World/Maps/Level_1.tscn")

func _ready():
	if GlobalControl.language_was_selected:
		language_selector.visible = false
		vbox_menu.visible = true
		pass
	pass

func _on_StartButton_pressed():
	transition.play("Fade Out")
	yield(transition, "animation_finished")
#	get_tree().change_scene_to(levelSelector)
	get_tree().change_scene_to(first_level)

func _on_ExitButton_pressed():
	get_tree().quit()


func _on_OptionsButton_pressed():
	options.visible = true

func play_unfade():
	transition.play("Fade Out")

func play_fade():
	transition.play("Show Title")



func _on_Credits_pressed():
	get_tree().change_scene("res://HUD/Credits.tscn")


func _on_LevelButton_pressed():
	get_tree().change_scene("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")



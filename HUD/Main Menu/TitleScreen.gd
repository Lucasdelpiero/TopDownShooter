extends Control

onready var options = $OptionsLayer/Options 

func _on_StartButton_pressed():
	get_tree().change_scene("res://World/World.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()

func _on_OptionsButton_pressed():
	options.visible = true

extends Control

onready var SliderSFX = $VBoxContainer/HBoxSFX/SliderSFX

func _on_CheckBox_toggled(button_pressed):
	OS.set_window_fullscreen(not OS.is_window_fullscreen())


func _on_ScreenResolution_item_selected(index):
	match index:
		0:
			OS.set_window_size(Vector2(1024, 600))
		1:
			OS.set_window_size(Vector2(1280, 1024))
		2:
			OS.set_window_size(Vector2(800, 600))
	OS.center_window()


func _on_SliderSFX_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

#   AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)



func _on_Mute_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), button_pressed)

func _input(event):
	if event.is_action_pressed("paused"):
		var new_pause_state = not get_tree().paused
		visible = new_pause_state




func _on_BackButton_pressed():
	visible = false
	if get_tree().is_paused():
		get_tree().paused = false
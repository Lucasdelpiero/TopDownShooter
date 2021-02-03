extends Control

onready var optionMusic = $VBoxContainer/BoxMusic/OptionMusic
onready var musicList = $VBoxContainer/BoxMusic/MusicList
onready var musicPlayer = $"/root/MusicPlayer"

onready var sliderMaster = $VBoxContainer/BoxMaster/SliderMaster
onready var sliderSFX = $VBoxContainer/BoxSFX/SliderSFX
onready var sliderMusic = $VBoxContainer/BoxMusic/SliderMusic
onready var min_value = sliderMaster.min_value


func _ready():
	randomize()
	getVolume("Master", sliderMaster)
	getVolume("Music", sliderMusic)
	getVolume("SoundEffects", sliderSFX)

	
	for i in musicList.tracks.size():
		optionMusic.add_item(musicList.tracks[i])
		optionMusic.text = "Choose Song"
		pass


func _input(event):
	if event.is_action_pressed("paused"):
		var new_pause_state = not get_tree().paused
		visible = new_pause_state

func _on_BackButton_pressed():
	visible = false
	if get_tree().is_paused():
		get_tree().paused = false

## SCREEN OPTIONS

func _on_CheckBox_toggled(_button_pressed):
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

## SOUND OPTIONS

func getVolume(bus, slider):
	var volume  = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))
	slider.value = volume

func setVolume(bus , value):
	if value == min_value :
		value = -72
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), value)
	print(value)

func mute(bus, button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), button_pressed)

func _on_SliderMaster_value_changed(value):
	setVolume("Master", value)

func _on_MuteMaster_toggled(button_pressed):
	mute("Master", button_pressed)

func _on_SliderSFX_value_changed(value):
	setVolume("SoundEffects", value)

func _on_MuteSFX_toggled(button_pressed):
	mute("SoundEffects", button_pressed)

func _on_SliderMusic_value_changed(value):
	setVolume("Music", value)

func _on_MuteMusic_toggled(button_pressed):
	mute("Music", button_pressed)

func chooseRandomSong():
	musicPlayer.stream = load ("res://Music/%s.ogg"  %musicList.tracks[randi() % musicList.tracks.size()] )
	musicPlayer.play()

func _on_OptionMusic_item_selected(index):
	musicPlayer.stream = load ("res://Music/%s.ogg"  %musicList.tracks[index] )
	musicPlayer.play()
	optionMusic.text = "Choose Song"

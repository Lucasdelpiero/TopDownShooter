extends Control

onready var optionMusic = $VBoxContainer/BoxMusic/OptionMusic
onready var musicList = $VBoxContainer/BoxMusic/MusicList
onready var musicPlayer = $"/root/MusicPlayer"

func _ready():
	randomize()
	for i in musicList.tracks.size():
		optionMusic.add_item(musicList.tracks[i])
		optionMusic.text = "Choose Song"
		pass
#	print(musicList.tracks.size())
#	optionMusic.add_item()

func _input(event):
	if event.is_action_pressed("paused"):
		var new_pause_state = not get_tree().paused
		visible = new_pause_state

func _on_BackButton_pressed():
	visible = false
	if get_tree().is_paused():
		get_tree().paused = false
#	print(musicPlayer.tracks[0])

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


func _on_SliderMaster_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_MuteMaster_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), button_pressed)

func _on_SliderSFX_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), value)

func _on_MuteSFX_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), button_pressed)

func _on_SliderMusic_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_MuteMusic_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), button_pressed)

func chooseRandomSong():
	musicPlayer.stream = load ("res://Music/%s.ogg"  %musicList.tracks[randi() % musicList.tracks.size()] )
	musicPlayer.play()

func _on_OptionMusic_item_selected(index):
	musicPlayer.stream = load ("res://Music/%s.ogg"  %musicList.tracks[index] )
	musicPlayer.play()
	optionMusic.text = "Choose Song"

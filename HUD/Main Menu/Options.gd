extends Control

onready var screenResolution = $VBoxContainer/HBoxScreen/ScreenResolution

onready var optionMusic = $VBoxContainer/BoxMusic2/OptionMusic
onready var musicList = $VBoxContainer/BoxMusic2/MusicList
onready var musicPlayer = $"/root/MusicPlayer"

onready var sliderMaster = $VBoxContainer/BoxMaster/SliderMaster
onready var sliderSFX = $VBoxContainer/BoxSFX/SliderSFX
onready var sliderMusic = $VBoxContainer/BoxMusic/SliderMusic
onready var min_value = sliderMaster.min_value

onready var muteMaster = $VBoxContainer/BoxMaster/MuteMaster
onready var muteSFX = $VBoxContainer/BoxSFX/MuteSFX
onready var muteMusic = $VBoxContainer/BoxMusic/MuteMusic


export var dynamicMusic = true
var dynamicActive = false
var dynamicVolume = 0.0
export var dynamicAccel = 0.02
var targetMusicVolume = 0.5

var pausable = true

signal updateLanguage(lang)

func _ready():
	visible = false
	randomize()
	getVolume("Master", sliderMaster)
	getVolume("Music", sliderMusic)
	getVolume("SoundEffects", sliderSFX)
	connectToText()
	
	for i in musicList.tracks.size():
		optionMusic.add_item(musicList.tracks[i])
#		optionMusic.text = "Choose Song"
		pass
	
	# Just padding
	optionMusic.text = "  %s" %musicList.tracks[0] 
	screenResolution.text = " %s " % [screenResolution.text] 

func _process(_delta):
	if dynamicMusic:
		dynamicVolumeUpdate(dynamicActive)

func _input(event):
	if event.is_action_pressed("paused"):
		var new_pause_state = not get_tree().paused
		visible = new_pause_state
#		print("bool: " + str(!new_pause_state))
	if event.is_action_pressed("reload"):
		dynamicActive = true

	if event.is_action_pressed("jump"):
		dynamicActive = false
	
	if pausable:
		if event.is_action_pressed("paused"):
			var new_pause_state = not get_tree().paused
			get_tree().paused = new_pause_state
			GlobalControl.showMouse(new_pause_state)



func _on_BackButton_pressed():
	visible = false
	if get_tree().is_paused():
		get_tree().paused = false
		GlobalControl.showMouse(false)

## SCREEN OPTIONS


func _on_CheckBox_toggled(_button_pressed):
	OS.set_window_fullscreen(not OS.is_window_fullscreen())


func _on_ScreenResolution_item_selected(index):
	var text : String = screenResolution.get_item_text(index) as String
	screenResolution.text = " %s " % [text] # Just padding inside of the button
	var parts = text.split("x") 
	
	if parts.size() <= 1: # Safeguard so it only accept text formatted like "1800x720"
		push_error("There is no 'x' so split screensize numbers")
		return
	
	var widht_string : String = parts[0]  
	var height_string : String = parts[1]
	var width  = float(widht_string)
	var height  = float(height_string)
	
	if width == 0 or height == 0: # In case at the left or right of the "x" is not a number
		push_error("width or hight size doesnt exists")
		return  
	
	OS.set_window_size(Vector2(width, height))
	OS.center_window()

## SOUND OPTIONS

func getVolume(bus, slider):
	var volume  = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))
	slider.value = db2linear(volume)

func setVolume(bus , value):
	if value <= linear2db(min_value) :
#		value = -72
		mute(bus, true)
		
	else:
		mute(bus, false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), value)
	updateMuted()

func mute(bus, value):
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), value)

func updateMuted():
	muteMaster.pressed = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	muteSFX.pressed = AudioServer.is_bus_mute(AudioServer.get_bus_index("SoundEffects"))
	muteMusic.pressed = AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))


func _on_SliderMaster_value_changed(value):
	setVolume("Master", linear2db(value))

func _on_MuteMaster_toggled(button_pressed):
	mute("Master", button_pressed)

func _on_SliderSFX_value_changed(value):
	setVolume("SoundEffects", linear2db(value))

func _on_MuteSFX_toggled(button_pressed):
	mute("SoundEffects", button_pressed)

func _on_SliderMusic_value_changed(value):
	setVolume("Music", linear2db(value) )
	targetMusicVolume = value

func _on_MuteMusic_toggled(button_pressed):
	mute("Music", button_pressed)

func chooseRandomSong():
	var newSong = randi() % musicList.tracks.size()
	musicPlayer.stream = load ("res://Music/%s.ogg"  %musicList.tracks[newSong])
	optionMusic.text = "  %s" % [musicList.tracks[newSong]]
	optionMusic.selected = newSong
	musicPlayer.play()

func _on_OptionMusic_item_selected(index):
	musicPlayer.stream = load ("res://Music/%s.ogg"  %musicList.tracks[index] )
	musicPlayer.play()
	optionMusic.text = "  %s" %musicList.tracks[index] 
#	optionMusic.text = "Choose Song"

## Dynamic  Music
func dynamicVolumeUpdate(value):
	dynamicVolume = lerp(dynamicVolume, float(value) , dynamicAccel)
	var totalVolume = dynamicVolume * targetMusicVolume
	setVolume("Music", linear2db(totalVolume))
	pass

func activateMusic(value):
	dynamicActive = value
#dynamicVolume = dynamicVolume.lerp( dynamicVolume, 0.2)



func _on_English_pressed():
	TranslationServer.set_locale("en")
	emit_signal("updateLanguage")


func _on_Spanish_pressed():
	TranslationServer.set_locale("es")
	emit_signal("updateLanguage")

func connectToText():
	var hasText = get_tree().get_nodes_in_group("hasText")
	for el in hasText:
		connect("updateLanguage", el, "updateText")

func _on_Change_Scene_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://HUD/Main Menu/Level Selector/LevelSelector.tscn")
	pass # Replace with function body.


func _on_Cheats_pressed():
	var firearm = get_tree().get_nodes_in_group("firearm")
	for el in firearm:
		print(el)
		el.reserveAmmo = el.capacity * 100
		el.ammo = el.capacity
	pass # Replace with function body.


func _on_ToMenu_pressed():
	get_tree().change_scene("res://HUD/Main Menu/TitleScreen.tscn")

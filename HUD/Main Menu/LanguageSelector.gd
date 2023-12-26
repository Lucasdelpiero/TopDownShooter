extends Control

#var mainMenu = preload("res://HUD/Main Menu/TitleScreen.tscn")
export(NodePath) var titleSceenP
onready var titleScreen = get_node(titleSceenP)
signal fade
signal updateLanguage(arg)

func _ready():
	connect("fade", titleScreen, "play_fade")
	connectToText()
	

func _on_BtnEnglish_pressed():
	TranslationServer.set_locale("en")
	emit_signal("updateLanguage")
	GlobalControl.language_was_selected = true
	play_transition()
	
func _on_BtnSpanish_pressed():
	TranslationServer.set_locale("es")
	emit_signal("updateLanguage")
	GlobalControl.language_was_selected = true
	play_transition()

func play_transition():
	emit_signal("fade")

func connectToText():
	var hasText = get_tree().get_nodes_in_group("hasText")
	for el in hasText:
		connect("updateLanguage", el, "updateText")

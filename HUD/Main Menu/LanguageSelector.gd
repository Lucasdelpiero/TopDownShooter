extends Control

#var mainMenu = preload("res://HUD/Main Menu/TitleScreen.tscn")
export(NodePath) var titleSceenP
onready var titleScreen = get_node(titleSceenP)
signal fade

func _ready():
	connect("fade", titleScreen, "play_fade")
	

func _on_BtnEnglish_pressed():
	TranslationServer.set_locale("en")
	play_transition()
	
func _on_BtnSpanish_pressed():
	TranslationServer.set_locale("es")
	play_transition()

func play_transition():
	emit_signal("fade")

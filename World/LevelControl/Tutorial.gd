extends Control

export(Color, RGBA) var defaultColor = Color(0.0, 0.0, 1.0, 1.0)

onready var tutoText = $CanvasLayer/TutoText
var textKey = ""

signal sendObjective(aCondition, aConditionAmount)
signal tutorialStart()

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.1),"timeout")
	var objectives = get_tree().get_root().find_node("Objectives", true, false)
	connect("sendObjective", objectives, "newObjectives")
	connect("tutorialStart", objectives, "activateTutorial")
	emit_signal("tutorialStart")
#	write("Press %0 Right Click %1 aaaa   %0 yes %1 alf ")
	pass # Replace with function body.

func useTextKey(aText : String ):
	textKey = aText
	var newText = tr(aText)
	write(newText)

func write( aText : String):
	var color = "#%s" % str(defaultColor.to_html())
	var newText = aText.format({"c" : "[color=%s]" % color} )
	newText = newText.format({"cc" : "[/color]"})
#	newText = aText.format(["[color=%s]" %color, "[/color]"] , "%_")
	tutoText.bbcode_text = "[center]%s[/center]" %newText

func sendObjective(aCondition, aContionAmount):
	emit_signal("sendObjective", aCondition, aContionAmount)
	pass

func updateText():
	useTextKey(textKey)
	pass



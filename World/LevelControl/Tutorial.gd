extends Control

export(Color, RGBA) var defaultColor = Color(0.0, 0.0, 1.0, 1.0)

export var tutoPath : NodePath 
onready var tutoText = get_node(tutoPath)

var textKey = ""
var last_text_entered = ""
onready var animation_player = $AnimationPlayer

export(float, 0.0, 5.0, 0.1) var time_to_dissapear = 1.0
export(float, 0.0, 5.0, 0.1) var time_to_appear = 1.0

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

func updateText(): # generally used to update when the language is changed 
	useTextKey(textKey)
	pass

func new_text_recieved(aText):
	var newText = tr(aText)
	if newText == last_text_entered: # so it only does the animation when recieves new text
		return
	
	if animation_player.get_assigned_animation() != "hide" and aText.length() <= 1:
		last_text_entered = ""
		animation_player.play("hide")
		return
	if aText.length() <= 1:  # An empty string is used to hide the text
		return
	
	if last_text_entered != "": # so it doesnt is played the first time
		animation_player.play("hide")
		yield(animation_player,"animation_finished")
	last_text_entered = newText
	write(newText)
	yield(get_tree().create_timer(0.2),"timeout")
	animation_player.play("show")


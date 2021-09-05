extends Control


onready var label = $CanvasLayer/Label

signal sendObjective(aCondition, aConditionAmount)

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.1),"timeout")
	var objectives = get_tree().get_root().find_node("Objectives", true, false)
	connect("sendObjective", objectives, "newObjectives")
	pass # Replace with function body.

func write( aText : String):
	label.text = aText

func sendObjective(aCondition, aContionAmount):
	emit_signal("sendObjective", aCondition, aContionAmount)
	pass

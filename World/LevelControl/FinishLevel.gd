extends Node

var objectiveNode = null
signal triggerFinishLevel

func _ready():
	objectiveNode = get_tree().get_root().find_node("Objectives", true, false)
	if objectiveNode != null:
		connect("triggerFinishLevel", objectiveNode, "finishLevel")

func activate():
	emit_signal("triggerFinishLevel")

func _on_TriggerFinishLevel_body_entered(body):
	activate()

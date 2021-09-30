extends Button

class_name MenuButtonClass

onready var audioHover = $AudioHover
onready var audioPressed = $AudioPressed
export(PackedScene) var transition = null

func _ready():
	var labelText = tr(text)
	text = "  %s   " %labelText

func _on_mouse_entered():
	audioHover.play()

func _on_mouse_exited():
	focus_mode = Control.FOCUS_NONE
	pass # Replace with function body.

func _on_pressed(): 
	audioPressed.play()
	if transition != null:
# warning-ignore:return_value_discarded
		get_tree().change_scene(transition.get_path()) 

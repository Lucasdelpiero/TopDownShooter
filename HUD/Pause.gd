extends Control

var pausable = true

func _input(event):
	if event.is_action_pressed("paused"):
		if pausable:
			var new_pause_state = not get_tree().paused
			get_tree().paused = new_pause_state
			GlobalControl.showMouse(new_pause_state)
			
			visible = new_pause_state

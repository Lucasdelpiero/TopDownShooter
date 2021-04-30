extends Button

signal diamondChosen(name)


func _on_LevelButton_pressed():
	emit_signal("diamondChosen", name)

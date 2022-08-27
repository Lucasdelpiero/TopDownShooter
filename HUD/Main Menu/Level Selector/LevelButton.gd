extends MenuButtonClass

signal diamondChosen(name)

func _on_LevelButton_pressed():
	emit_signal("diamondChosen", name)
	audioPressed.play()

func _on_LevelButton_mouse_entered():
	audioHover.play()
	anim_set_large()

func _on_LevelButton_mouse_exited():
	anim_set_normal()

extends Node


func play(name):
	if name:
		get_node(name).play()


func _on_Timer_timeout():
	queue_free()

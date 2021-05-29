extends Button

class_name MenuButtonClass

onready var audioHover = $AudioHover
onready var audioPressed = $AudioPressed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_mouse_entered():
	audioHover.play()


func _on_mouse_exited():
	pass # Replace with function body.


func _on_pressed():
	audioPressed.play()

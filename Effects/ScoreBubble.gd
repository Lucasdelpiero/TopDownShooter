extends Node2D

onready var richLabel = $RichTextLabel
export(float, 1, 10) var length = 9.0
export var text = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Fade Out")
	pass # Replace with function body.






# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var text = "[fade start=0 length=%s ]%s[/fade]" 
#	var textF = text % [str(length), texto]
#	print( textF)
#	richLabel.bbcode_text = str(textF)


	
	pass


func _on_Timer_timeout():
	if length > 1.1:
		length -= 0.050
	
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
#	queue_free()
	pass # Replace with function body.

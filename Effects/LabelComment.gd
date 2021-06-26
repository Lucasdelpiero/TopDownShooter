extends Node2D

onready var tween = $Tween
onready var label = $Label

export(float, 1.0, 2.5, 0.1 ) var scale_end = 2.0

var rotation_range = 35.0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#Move Up
	tween.interpolate_property(label, "rect_position", label.rect_position , Vector2(0.0, -1000.0), 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	#Rotate
	var init_rotation = rand_range(-rotation_range / 2, rotation_range / 2) 
	var final_rotation = init_rotation + rand_range(0, init_rotation  ) * sign(init_rotation)
	tween.interpolate_property(label, "rect_rotation", init_rotation, final_rotation, 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	#Change Size
	var scale_final = Vector2(scale_end, scale_end)
	tween.interpolate_property(label, "rect_scale", label.rect_scale , scale_final, 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	

func comment(value):
	label.text = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Tween_tween_all_completed():
	queue_free()

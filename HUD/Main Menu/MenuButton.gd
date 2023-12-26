extends Button

class_name MenuButtonClass

onready var audioHover = $AudioHover
onready var audioPressed = $AudioPressed
export(PackedScene) var transition = null
onready var tween := $Tween
onready var key = text

var normal_scale := Vector2(1.0, 1.0)
var large_scale := Vector2(1.1, 1.1)
export(float, 0.05, 0.5, 0.02) var anim_time = 0.25



func _ready():
	var labelText = tr(key)
	text = "  %s   " %labelText
	rect_pivot_offset = rect_size / 2 # pivot so when get larger in animation its centered
	updateText()

func _on_mouse_entered():
	audioHover.play()
	anim_set_large()

func _on_mouse_exited():
	focus_mode = Control.FOCUS_NONE
	anim_set_normal()


func _on_pressed(): 
	audioPressed.play()
	anim_set_normal()
	anim_set_large()
	
	if transition != null:
# warning-ignore:return_value_discarded
		get_tree().change_scene(transition.get_path()) 

func anim_set_large():
	if !disabled:
		tween.interpolate_property(self, "rect_scale", normal_scale, large_scale, anim_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()

func anim_set_normal():
	if !disabled:
		tween.interpolate_property(self, "rect_scale", large_scale, normal_scale, anim_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()

func updateText():
	text = "  %s  " % [tr(key)]

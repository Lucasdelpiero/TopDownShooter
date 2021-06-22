extends Node2D

onready var richLabel = $RichTextLabel
#onready var label = $Label
export(NodePath) var lScoreP
onready var lScore = get_node(lScoreP)
export(NodePath) var lMultiplierP
onready var lMultiplier = get_node(lMultiplierP)
export(float, 1, 10) var length : float = 9.0
export var text = ""
export(Color, RGB) var color_0 
export(Color, RGB) var color_1 
export(Color, RGB) var color_2 
export(Color, RGB) var color_3 
export(Color, RGB) var color_4 

var score = 0
var multiplier = 0 

var Colors = [
]

# Called when the node enters the scene tree for the first time.
func _ready():
	Colors = [
	color_0,
	color_1,
	color_2,
	color_3,
	color_4,
]
	randomize()
	
	lScore.modulate = Color(1.0, 0.0, 0.0)
	lScore.modulate = Colors[int(round(rand_range(0.0, 4.0)))]
	$AnimationPlayer.play("Fade Out")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	var text = "[fade start=0 length=%s ]%s[/fade]" 
#	var textF = text % [str(length), texto]
#	print( textF)
#	richLabel.bbcode_text = str(textF)
	pass
	
func setValues(aScore, aMultiplier):
	score = aScore
	multiplier = aMultiplier
	lScore.text = str(score)
	lMultiplier.text = "x" + str(multiplier)

func _on_Timer_timeout():
	if length > 1.1:
		length -= 0.050

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

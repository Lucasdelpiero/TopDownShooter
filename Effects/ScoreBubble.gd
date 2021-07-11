extends Node2D

onready var LabelComment = preload("res://Effects/LabelComment.tscn")
onready var richLabel = $RichTextLabel
#onready var label = $Label
export(NodePath) var lScoreP
onready var lScore = get_node(lScoreP)
export(NodePath) var lMultiplierP
onready var lMultiplier = get_node(lMultiplierP)
export(float, 1, 10) var length : float = 9.0
export var text = ""
export(Array, Color, RGB) var Colors

var score = 0
var multiplier = 0 

signal setComment(value)

var comments = {
	3 : "Good",
	5 : "Better",
	10 : "Nice",
	20 :"Bloodthisthy",
	30 : "Massacre",
	12 : "Nice",
	14 : "Nice",
	16 : "Nice",
	1 : "Nice",
}

# Called when the node enters the scene tree for the first time.
func _ready():

	randomize()
	
#	lScore.modulate = Colors[int(round(rand_range(0.0, 4.0)))]
#	$AnimationPlayer.play("Fade Out")
	$AnimationPlayer.play("Fade")

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
	multiplierColor(aMultiplier)
	if aMultiplier in comments:
		commentCreate(aMultiplier)

func multiplierColor(value):
	if value < 3:
		mColor(0)
	elif value < 5:
		mColor(1)
	elif value < 10:
		mColor(2)
	elif value < 20:
		mColor(3)
	else:
		mColor(4)

func mColor(a):
	lMultiplier.modulate = Colors[a]

func commentCreate(value):
	var labelComment = LabelComment.instance()
	get_parent().add_child(labelComment)
	labelComment.global_position = global_position
# warning-ignore:return_value_discarded
	connect("setComment", labelComment, "comment")
	emit_signal("setComment", comments[value])
	disconnect("setComment", labelComment, "comment")

func _on_Timer_timeout():
	if length > 1.1:
		length -= 0.050

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

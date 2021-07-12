extends Control

export(NodePath) var containerP
onready var container = get_node(containerP)
export(NodePath) var lMultiplierP
onready var lMultiplier = get_node(lMultiplierP)
export(NodePath) var lMessageP
onready var lMessage = get_node(lMessageP)
onready var VBC = $VBC

onready var shakeTimer = $ShakeTimer
onready var stopShakeTimer = $StopShakeTimer

var canShake = true
var shaking = false
export var offset = 2.0


var Colors = []

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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func updateMultiplicator(value):
	lMultiplier.text = "x " + str(value)
	multiplierColor(value)
	shake(VBC)
	if value in comments:
#		shake(lMessage)
		displayMessage(comments[value])

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
	container.self_modulate = get_parent().Colors[a]

func shake(object):
	var osx = rand_range(-offset, offset)
	var osy = rand_range(-offset, offset)
	object.rect_position = Vector2(osx, osy)
	if not shaking:
		shakeTimer.start()
		stopShakeTimer.start()
	shaking = true

func _on_ShakeTimer_timeout():
	if canShake:
		shake(VBC)

func _on_StopShakeTimer_timeout():
	canShake = true
	shaking = false
	shakeTimer.stop()
	VBC.rect_position = Vector2(0.0, 0.0)

func displayMessage(value : String):
	lMessage.text = value
	lMessage.visible = true
	
	pass

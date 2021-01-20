extends Control

tool

var test = 14
onready var main = get_parent().get_parent()
var size = 256

var testing = false
var isObject = false

onready var label0 = $VBoxContainer/Label0
onready var label1 = $VBoxContainer/Label1
onready var label2 = $VBoxContainer/Label2
onready var label3 = $VBoxContainer/Label3
onready var label4 = $VBoxContainer/Label4
onready var label5 = $VBoxContainer/Label5

export var debug0 = ""
export var debug1 = ""
export var debug2 = ""
export var debug3 = ""
export var debug4 = ""
export var debug5 = ""


#func _ready():
#	set_global_position(main.get_global_position())
#	for i in range(5):
#		updateDebugger(i)

func _process(_delta):
	for i in range(6):
		updateDebugger(i)

func updateDebugger(number):
	set_global_position(main.get_global_position())
	var label = get_node("VBoxContainer/Label%s" % str(number))
	var debug = get("debug" + str(number))
	if str2var(debug) in main:
		label.text = debug + ": "+ str(main.get(debug))
	else:
		if debug == "":
			label.text = ""
		elif str2var(debug) == null:
			label.text = '"' + debug + '"'  + ": " + "Is Null"
		else:
			label.text = '"' + debug + '"'  + ": " + "Variable not exists"

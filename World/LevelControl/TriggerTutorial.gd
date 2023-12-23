extends Area2D

# Node used in tutorial to activate a message to show what to do

export(String, MULTILINE) var text = "" # KEY used to get the text to show

# Who can trigger the node
export var playerTrigger = false
export var zombiTrigger = false
export var damageTrigger = false

export(String, "none","kill", "melee","explosion") var condition = "none"
export(int, 1, 10) var conditionAmount = 1
var parent 

onready var hitbox = $CollisionShape2D

signal send_text(text)
signal send_objective(condition, conditionAmount)

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	yield(get_tree().create_timer(0.1), "timeout")
	parent = get_parent()
	connect("send_text", parent, "new_text_recieved")
	connect("send_objective", parent, "sendObjective")
	set_collision_mask_bit(0, playerTrigger)
	set_collision_mask_bit(1,zombiTrigger)
	if damageTrigger:
		set_collision_mask_bit(3,damageTrigger)
		set_collision_mask_bit(3,damageTrigger)

func sendInfo():
#	var newText = tr(text) #To get the translation
	emit_signal("send_text", text)
	emit_signal("send_objective", condition, conditionAmount)

func _on_body_entered(_body):
	sendInfo()

func _on_area_entered(_area):
	pass
#	sendInfo()



extends Area2D

export var text = ""
export var playerTrigger = false
export var zombiTrigger = false
export var damageTrigger = false


onready var hitbox = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	print(text)
	print("player: " + str(playerTrigger))
	set_collision_mask_bit(0, playerTrigger)
	set_collision_mask_bit(1,zombiTrigger)
	if damageTrigger:
		set_collision_mask_bit(3,damageTrigger)
		set_collision_mask_bit(3,damageTrigger)

func sendInfo():
	get_parent().write(text)
	pass

func _on_body_entered(body):
	sendInfo()

func _on_area_entered(area):
	sendInfo()


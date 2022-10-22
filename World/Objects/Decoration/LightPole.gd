extends StaticBody2D

var interval = 1 # Interval between a normal light and flashing
onready var timer = $Timer
onready var animPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_interval()


func _on_Timer_timeout():
	animPlayer.play("Flashing")

func idle():
	animPlayer.play("Idle")

func new_interval():
	interval = rand_range(3,8)
	timer.wait_time = interval
	timer.start()

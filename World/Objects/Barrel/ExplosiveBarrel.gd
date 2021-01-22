extends StaticBody2D

export var health = 2
var exploted = false
onready var Explosion = preload("res://World/Objects/Barrel/Explosion.tscn")
onready var timer = $Timer

func _ready():
	randomize()

func _on_HurtBox_area_entered(area):
	health -= area.damage
	if health < 1 and not exploted:
		#Called deferred because of a bug
		exploted = true
#		call_deferred("createExplosion")
		timer.start(rand_range(0.0, 0.3))

		
func createExplosion():
	var explosion = Explosion.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	health = 100000
	queue_free()






func _on_Timer_timeout():
	createExplosion()

extends StaticBody2D

export var health = 2
var exploted = false
onready var Explosion = preload("res://World/Objects/Barrel/Explosion.tscn")


func _on_HurtBox_area_entered(area):
	health -= area.damage
	if health < 1 and not exploted:
		#Called deferred because of a bug
		exploted = true
		call_deferred("createExplosion")
		
func createExplosion():
	var explosion = Explosion.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	health = 100000
	queue_free()





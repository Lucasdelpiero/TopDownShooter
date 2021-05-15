extends StaticBody2D

onready var sprite = $Sprite
var DoorParticles = preload("res://World/Objects/Decoration/DoorParticles.tscn")

func _on_Area2D_area_entered(_area):
	var doorParticles = DoorParticles.instance()
	get_tree().get_root().add_child(doorParticles)
	doorParticles.global_position = global_position
	doorParticles.rotation = rotation
	queue_free()


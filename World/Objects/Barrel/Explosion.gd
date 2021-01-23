extends Node2D

onready var animation = $AnimationPlayer
var direction = 0

func _process(delta):
	animation.play("Explosion")





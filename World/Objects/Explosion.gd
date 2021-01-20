extends Node2D

onready var animation = $AnimationPlayer

func _process(delta):
	animation.play("Explosion")





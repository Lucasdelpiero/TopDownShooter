extends Node2D

onready var animation = $AnimationPlayer
var direction = 0
var soundAmount = 3

func _ready():
	var amount = get_tree().get_nodes_in_group("Explosion").size()
	if amount <= soundAmount:
		$AudioStreamPlayer.play()

func _process(_delta):
	animation.play("Explosion")





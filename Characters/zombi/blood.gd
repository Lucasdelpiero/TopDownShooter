extends Node2D

onready var sprite = $Sprite
onready var audioStreamPlayer = $AudioStreamPlayer

func _ready():
	sprite.frame = 0
	var pitch = rand_range(0.8, 1.2)
	audioStreamPlayer.pitch_scale = pitch

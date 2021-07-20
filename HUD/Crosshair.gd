extends Control

export(Array, Color) var Colors
onready var ammoBar = $AmmoBar

func _process(_delta):
	rect_position = get_viewport().get_mouse_position() 

func updateAmmo(ammo , capacity):
	ammoBar.value = int(ammo)
	ammoBar.max_value = int(capacity)
	tint(  float(ammo) / float(capacity) )

func tint(value : float):
	if value >= 0.8:
		ammoBar.tint_progress = Colors[0]
	elif value >= 0.5:
		ammoBar.tint_progress = Colors[1]
	elif value >= 0.3:
		ammoBar.tint_progress = Colors[2]
	else:
		ammoBar.tint_progress = Colors[3]


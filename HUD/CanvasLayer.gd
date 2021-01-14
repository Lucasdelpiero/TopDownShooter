extends CanvasLayer

onready var ammo = 0
onready var capacity = 0

onready var healthBar = $Control/VBoxContainer/LifeBar
onready var label = $Control/VBoxContainer/HBoxContainer/Label


func _on_Player_updateHUD(health, ammo, capacity):
	healthBar.value = health
	label.text = str(ammo) + " / " + str(capacity)

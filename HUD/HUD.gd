extends CanvasLayer

onready var ammo = 0
onready var capacity = 0

onready var healthBar = $Control/VBoxContainer/LifeBar
onready var label = $Control/VBoxContainer/HBoxContainer/Label
onready var gridContainer = $GridContainer

export(Color, RGBA) var defaultColor = Color(1.0, 1.0, 1.0, 1.0)
export(Color, RGBA) var selectedColor = Color(1.0, 0.0, 0.0, 1.0)

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _on_Player_updateHUD(health, ammo, capacity):
	healthBar.value = health
	label.text = str(ammo) + " / " + str(capacity)

func _on_Player_updateHUDWeapon(name):
	#Resets color for all
	for i in gridContainer.get_children():
		i.modulate = Color(defaultColor)
	
	#Sets the color to the selected color
	var icon = get_node("GridContainer/Icon%s" %name)
	var label = get_node("GridContainer/Label%s" %name)
	if icon != null:
		icon.modulate = Color(selectedColor)
	if label != null:
		label.modulate = Color(selectedColor)



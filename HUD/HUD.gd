extends CanvasLayer

onready var ammo = 0
onready var capacity = 0

onready var healthBar = $Control/VBoxContainer/LifeBar
onready var label = $Control/VBoxContainer/HBoxContainer/Label
onready var gridContainer = $GridContainer
onready var crosshair = $Crosshair

export(Color, RGBA) var defaultColor = Color(1.0, 1.0, 1.0, 1.0)
export(Color, RGBA) var selectedColor = Color(1.0, 0.0, 0.0, 1.0)

var optionsControl

func _ready():
	yield(get_tree().create_timer(0.05), "timeout")
	optionsControl = get_tree().get_root().find_node("Options", true, false)
#	connect("updateMusic", optionsControl, "activateMusic")

func _process(_delta):
#	crosshair.rect_position = get_viewport().get_mouse_position() 
	if Input.is_action_just_pressed("restart"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()


func _on_Player_updateHUDWeapon(name):
	#Resets color for all
	for i in gridContainer.get_children():
		i.modulate = Color(defaultColor)
	
	#Sets the color to the selected color
	if has_node("GridContainer/Icon%s" %name):
		var icon = get_node("GridContainer/Icon%s" %name)
		var labels = get_node("GridContainer/Label%s" %name)
		if icon != null:
			icon.modulate = Color(selectedColor)
		if labels != null:
			labels.modulate = Color(selectedColor)

func _on_Update_Ammo(aAmmo, aCapacity):
	label.text = str(aAmmo) + " / " + str(aCapacity)

func _on_Player_updateHealth(aHealth):
	healthBar.value = aHealth

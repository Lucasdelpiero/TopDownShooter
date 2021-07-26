extends CanvasLayer

onready var ammo = 0
onready var capacity = 0
var weaponSelected = 0

onready var healthBar = $Control/VBoxContainer/LifeBar
onready var label = $Control/VBoxContainer/HBoxContainer/Label
onready var gridContainer = $GridContainer
onready var weaponsSlots = $WeaponsSlots
onready var crosshair = $Crosshair

var iconImages = {
	"Rifle" : "res://HUD/Weapons/rifle_icon.png" ,
	"Pistol" : "res://HUD/Weapons/pistol_icon.png",
	"Shotgun" : "res://HUD/Weapons/shotgun_icon.png",
}

export(Color, RGBA) var defaultColor = Color(1.0, 1.0, 1.0, 1.0)
export(Color, RGBA) var selectedColor = Color(1.0, 0.0, 0.0, 1.0)

onready var iconBase = preload("res://HUD/Weapons/IconBase.tscn")

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

func updateWeaponSelected( selected : int):
	var weaponList = weaponsSlots.get_children()
	weaponSelected = selected
	for i in weaponList.size():
		if i == weaponSelected:
			weaponList[i].modulate = Color(selectedColor)
		else:
			weaponList[i].modulate = Color(defaultColor)

func _on_Update_Ammo(aAmmo, aCapacity, aReserve):
	label.text = str(aAmmo) + " / " + str(aReserve)
	crosshair.updateAmmo(aAmmo, aCapacity)

func _on_Player_updateHealth(aHealth):
	healthBar.value = aHealth

func updateHUDWeapons( weaponList : Array ):
	for i in weaponList.size():
		print(str(weaponList[i].name) + ",type: " + str(weaponList[i].type) )
	deleteIcons()
	createIcons(weaponList)

func deleteIcons():
	var icons = weaponsSlots.get_children()
	for i in icons.size():
		icons[i].queue_free()

func createIcons( weaponList : Array ):
	for i in weaponList.size():
		var icon = iconBase.instance()
		weaponsSlots.add_child(icon)
		var typeWeapon = weaponList[i].type
		icon.texture = load(iconImages[typeWeapon])
		icon.get_child(0).text = "[%s]" %str(i + 1)

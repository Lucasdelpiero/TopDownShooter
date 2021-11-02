extends Sprite

var weaponList = {
	"Rifle" : "res://Characters/Player/Top_Down_Survivor/rifle/Rifle.tscn",
	"Shotgun" : "res://Characters/Player/Top_Down_Survivor/shotgun/Shotgun.tscn",
	"Pistol" :"res://Characters/Player/Top_Down_Survivor/pistol/Pistol.tscn",
	"SuperRifle" : "res://Characters/Player/Top_Down_Survivor/rifle/SuperRifle.tscn",
	"SuperShotgun" : "res://Characters/Player/Top_Down_Survivor/shotgun/SuperShotgun.tscn",
}
export(String, "Rifle", "Shotgun", "Pistol", "SuperRifle", "SuperShotgun") var weapon = "Rifle"

onready var tween := $Tween
onready var startingPos = global_position
export var offsetAnim = 100
export var timeAnim = 1.0
var transition = Tween.TRANS_SINE
var easing = Tween.EASE_IN_OUT
onready var endPos = startingPos + Vector2(0.0, offsetAnim)
var weaponPath 

signal pickWeapon(path)

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponPath = weaponList[weapon]
	var Weapon = load(weaponPath)
	var newWeapon = Weapon.instance()
	call_deferred("add_child", newWeapon)
	idleAnimation()
	setSprite(WeaponList.getImage(weapon))


func _on_Area2D_body_entered(body):
	connect("pickWeapon", body, "grabWeapon")
	emit_signal("pickWeapon", weaponPath)
	disconnect("pickWeapon", body, "grabWeapon")
	
func idleAnimation():
	tween.interpolate_property(self,"global_position", startingPos , endPos, timeAnim, transition,easing)
	tween.start()
	tween.interpolate_property(self,"global_position", endPos ,startingPos , timeAnim ,transition,easing, timeAnim)
	tween.start()
	tween.repeat = true
	pass

func setSprite(path):
	texture = load(path)
	

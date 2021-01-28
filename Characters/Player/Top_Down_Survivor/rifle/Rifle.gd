extends Position2D

export var automatic = false
export var capacity = 12
onready var ammo = capacity
export var idleTime = 1.0
export var missDegree = 20
export var bulletsShot = 12
export var damage = 1
export var weaponRange = 2000
export(Resource) var shotSound 
export(Resource) var reloadSound



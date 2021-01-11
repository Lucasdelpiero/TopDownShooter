extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

export var zoomSpeed = 20.0

var zoomMin = 0.5
var zoomMax = 8.0

var zoomfactor = 1.0
var zooming = false

# Called when the node enters the scene tree for the first time.
func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_right = bottomRight.position.x
	limit_bottom = bottomRight.position.y
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomSpeed * delta)
	zoom.y = lerp(zoom.y, zoom.x * zoomfactor, zoomSpeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
	if not zooming:
		zoomfactor = 1.0
	

func _input(_event):
	if Input.is_action_pressed("zoom_in"):
		zoomfactor -= 0.01 * zoomSpeed
		zooming = true
	elif Input.is_action_pressed("zoom_out"):
		zoomfactor += 0.01 * zoomSpeed
		zooming = true
	else:
		zooming = false

extends Camera3D

@export var setAngle:float = 1.85
@export var setYPos:float = 6
@export var radius:float = 8
@export var lookAt:Vector3 = Vector3(0,2,0)
@export var sensitivity:float = 0.01

var angle = setAngle
var yPos = setYPos

var initMousePos:Vector2
var initAngle:float
var initYpos: float
var offset:Vector2
var dragging:bool = false

func _ready():
	set_cam_pos()

func _process(_delta):
	look_at(lookAt)
	
	if Input.is_action_just_pressed("click"):
		dragging = true
		initAngle = angle
		initYpos = yPos
		initMousePos = get_viewport().get_mouse_position()
	if Input.is_action_just_released("click"):
		dragging = false
	if Input.is_action_just_pressed("r_click"):
		angle = setAngle
		yPos = setYPos
		set_cam_pos()
		
	if dragging:
		set_cam_pos()
		offset = initMousePos - get_viewport().get_mouse_position()
		angle = lerp(initAngle, initAngle - offset.x*sensitivity, 0.03)
		yPos = lerp(initYpos, initYpos - offset.y*sensitivity, 0.2)
		yPos = min(15,yPos)
		yPos = max(-5,yPos)
		
func set_cam_pos():
	position.x = radius * cos(angle)
	position.y = yPos
	position.z = radius * sin(angle)

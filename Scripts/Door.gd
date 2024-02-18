@tool
extends PhysicsObj

@export var dir = Vector3.ZERO
var whatsBehind = []
var n = 0
var m = 0

func _ready():
	colShape.scale = scaling
	meshInst.scale = scaling
	initialPos = position
	
	if dir.x != 0:
		n = scaling.y
		m = scaling.z
	if dir.y != 0:
		n = scaling.z
		m = scaling.x
	if dir.z != 0:
		n = scaling.y
		m = scaling.x
		
	for i in range(n):
		whatsBehind.append([])
		whatsBehind[i] = []
		for j in range(m):
			whatsBehind[i].append([])
			whatsBehind[i][j] = 0

func _physics_process(_delta):
	if Engine.is_editor_hint():
		return
	
	ray.target_position = dir * 30
	for x in range(scaling.x):
		for y in range(scaling.y):
			for z in range(scaling.z):
				ray.position = Vector3(x-0.5*(scaling.x-1),-y+0.5*(scaling.y-1),-z+0.5*(scaling.z-1))
				ray.force_raycast_update()
				if ray.is_colliding() == true:
					set_behind(BehindObjs.objs.SOLID,x,y,z)
				else:
					set_behind(BehindObjs.objs.EMPTY,x,y,z)

func set_behind(col,x,y,z):
	if dir.x != 0:
		whatsBehind[y][z] = col
	if dir.y != 0:
		whatsBehind[z][x] = col
	if dir.z != 0:
		whatsBehind[y][x] = col

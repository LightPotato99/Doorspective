class_name PhysicsObj
extends StaticBody3D

@onready var ray: RayCast3D = $Ray
@onready var colShape: CollisionShape3D = $CollisionShape3D
@onready var meshInst: Node3D = $MeshInstance3D

@export var scaling: Vector3i = Vector3.ONE

var isMoving:bool = false
var posRecord:PackedVector3Array
var initialPos:Vector3
var activeGrav:bool = false

signal move_sideways

var fallY = -6

func _ready():
	colShape.scale = scaling
	meshInst.scale = scaling
	initialPos = position
	
func get_colliders(vec:Vector3, length:int = 1):
	var colliders = []
	ray.target_position = vec * length
	for x in range(scaling.x):
		for y in range(scaling.y):
			for z in range(scaling.z):
				ray.position = Vector3(x-0.5*(scaling.x-1),y-0.5*(scaling.y-1),z-0.5*(scaling.z-1))
				ray.force_raycast_update()
				if ray.is_colliding() == true:
					colliders.append(ray.get_collider())
					
	return colliders
		
func can_move(vec:Vector3):
	
	if vec == Vector3.DOWN:
		if activeGrav == false:
			activeGrav = true
			return false
		if position.y < fallY:
			colShape.disabled = true
			return false

	var colliders = get_colliders(vec)
	for col in colliders:
		if not col.is_in_group('box'):
			return false
		if not col.can_move(vec):
			return false
	
	for col in colliders:
		col.move(vec)
	return true
	
func undo():
	var undoed = 0
	if not posRecord.is_empty():
		position = posRecord[-1]
		posRecord.remove_at(posRecord.size()-1)
		undoed = 1
	if position.y >= fallY:
		colShape.disabled = false
		
	return undoed
		
func reset():
	posRecord.clear()
	position = initialPos
	colShape.disabled = false

func savePos():
	posRecord.append(position)
		
func move(vec:Vector3) -> void:
	if isMoving == false:
		isMoving = true
		
		var tween = create_tween()
		if vec != Vector3.DOWN:
			tween.tween_property(self,"position",position+vec,0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			move_sideways.emit()
		else:
			tween.tween_property(self,"position",position+vec,0.01)
		apply_friction(vec)
		await tween.finished
				
		isMoving = false
		
func apply_friction(vec:Vector3):
	var colliders = get_colliders(Vector3.UP)
	for col in colliders:
		if col.is_in_group('box') and col.can_move(vec):
			col.move(vec)

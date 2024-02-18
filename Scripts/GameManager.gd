extends Node3D

@onready var player = $Player
@onready var door = $Door

var sfxPlayer:AudioStreamPlayer
var sfxUndo = preload("res://Sounds/SFX/Undo.wav")
var sfxReset = preload("res://Sounds/SFX/Reset.wav")
var sfxMove = preload("res://Sounds/SFX/Move.wav")
var sfxSuccess = preload("res://Sounds/SFX/Success.wav")

var lvPack:LevelPack
var n:int = 0
var m:int = 0
var level:int = 0
var physicsObjs = []
var canCtrl:bool = true
var transitionStart:bool = false

func _ready():
	sfxPlayer = AudioStreamPlayer.new()
	add_child(sfxPlayer)
	n = door.n
	m = door.m
	level = int(get_tree().get_current_scene().get_name().substr(5))
	lvPack = load("res://Levels/Level"+str(level)+".tres")
	for child in get_children():
		if child is PhysicsObj:
			physicsObjs.append(child)

func _process(_delta):
	if check_solved() == true and transitionStart == false:
		await get_tree().create_timer(0.1).timeout
		if check_solved() == true and transitionStart == false:
			play_sound(sfxSuccess)
			if level < 10:
				Transition.change_scene("Levels/Level"+str(level+1))
			else:
				Transition.change_scene("Congrats")
			transitionStart = true
			#get_tree().change_scene_to_file("res://Scenes/Levels/Level"+str(level+1)+".tscn")
	
	if canCtrl and transitionStart == false:
		if Input.is_action_just_pressed("ui_up"):
			process_input(Vector3.FORWARD)
		if Input.is_action_just_pressed("ui_down"):
			process_input(Vector3.BACK)
		if Input.is_action_just_pressed("ui_left"):
			process_input(Vector3.LEFT)
		if Input.is_action_just_pressed("ui_right"):
			process_input(Vector3.RIGHT)
		if Input.is_action_just_pressed("undo"):
			var undoObj = 0
			for obj in physicsObjs:
				undoObj += obj.undo()
			if undoObj >= 1:
				play_sound(sfxUndo)
		if Input.is_action_just_pressed("restart"):
			for obj in physicsObjs:
				obj.reset()
			play_sound(sfxReset)
		canCtrl = false
	
	if canCtrl == false:
		var nowCtrl = true
		for obj in physicsObjs:
			if obj.isMoving == true:
				nowCtrl = false
		canCtrl = nowCtrl
		
func process_input(dir:Vector3):
	if player.position.y < -4:
		return
	if player.can_move(dir):
		player.move(dir)
		for obj in physicsObjs:
			obj.savePos()
		play_sound(sfxMove)
	
func play_sound(sfx):
	sfxPlayer.stream = sfx
	sfxPlayer.play()
	
func check_solved():
	var solved = true
	for i in range(n):
		for j in range(m):
			if door.whatsBehind[i][j] != lvPack.targets[i*m+j]:
				solved = false
	return solved

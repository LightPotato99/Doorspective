extends Control

var level = 0
var lvPack:LevelPack
var n:int = 0
var m:int = 0

@onready var door = %Door
@onready var lvText = $Level

var sqSize = 0

func _ready():
	n = door.n
	m = door.m
	level = int(get_tree().get_current_scene().get_name().substr(5))
	lvPack = load("res://Levels/Level"+str(level)+".tres")
	sqSize = 100 / max(n,m)
	
func get_color(obj):
	match obj:
		BehindObjs.objs.SOLID:
			return Color.BLACK
		BehindObjs.objs.EMPTY:
			return Color.WHITE

func _draw():
	for i in range(n):
		for j in range(m):
			var drawX = 132-sqSize*(m/2.)+j*sqSize
			var drawY = 280-sqSize*(n/2.)+i*sqSize
			draw_rect(Rect2(drawX,drawY,sqSize,sqSize),get_color(door.whatsBehind[i][j]))
			draw_rect(Rect2(drawX,drawY+250,sqSize,sqSize),get_color(lvPack.targets[i*m+j]))

func _process(_delta):
	queue_redraw()
	lvText.text = "Level " + str(level) + "/10"

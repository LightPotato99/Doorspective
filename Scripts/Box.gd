@tool
extends PhysicsObj

@onready var sfxPlayer = $AudioStreamPlayer

func _physics_process(_delta):
	if Engine.is_editor_hint():
		return
		
	if can_move(Vector3.DOWN):
		move(Vector3.DOWN)
		return


func _on_move_sideways():
	sfxPlayer.play()

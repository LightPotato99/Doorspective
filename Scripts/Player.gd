extends PhysicsObj

func _physics_process(_delta):
	if can_move(Vector3.DOWN):
		move(Vector3.DOWN)
		return

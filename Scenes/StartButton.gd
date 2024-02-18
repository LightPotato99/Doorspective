extends Button

func _on_pressed():
	Transition.change_scene("Levels/Level1")
	$AudioStreamPlayer.play()

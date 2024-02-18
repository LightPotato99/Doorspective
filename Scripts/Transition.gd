extends CanvasLayer

func begin():
	$AnimationPlayer.play("transitionOut")
	
func change_scene(sceneName):
	var scene = "res://Scenes/" + sceneName + ".tscn"
	$AnimationPlayer.play('RESET')
	$AnimationPlayer.play('transitionIn')
	await $AnimationPlayer.animation_finished
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file(scene)
	$AnimationPlayer.play("transitionOut")

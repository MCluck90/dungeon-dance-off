extends "Startup.gd"

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _on_next_level(scene_path):
	get_tree().change_scene(scene_path)

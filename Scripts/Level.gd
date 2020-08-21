extends "Startup.gd"

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		return get_tree().reload_current_scene()

func _on_next_level(scene_path):
	return get_tree().change_scene(scene_path)

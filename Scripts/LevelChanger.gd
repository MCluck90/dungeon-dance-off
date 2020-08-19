extends Node2D

func _ready():
	var screen_size = OS.get_screen_size(0)
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)
	OS.vsync_enabled = false

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _on_next_level(scene_path):
	get_tree().change_scene(scene_path)

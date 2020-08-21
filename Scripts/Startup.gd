extends Node2D

func _ready():
	# TODO: Only run this on startup, not in every scene
	var screen_size = OS.get_screen_size(0)
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)
	OS.vsync_enabled = false

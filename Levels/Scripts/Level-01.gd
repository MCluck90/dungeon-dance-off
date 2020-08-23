extends "res://Scripts/Level.gd"

onready var MusicManager = get_node("/root/MusicManager")

func _ready():
	MusicManager.play_level_music()

extends "Startup.gd"

onready var Globals = get_node("/root/Globals")
var start_score = 0

func _ready():
	start_score = Globals.score

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		Globals.set_score(start_score)
		return get_tree().reload_current_scene()

func _on_next_level(scene_path):
	return get_tree().change_scene(scene_path)

func on_death():
	Globals.set_score(start_score)
	return get_tree().reload_current_scene()

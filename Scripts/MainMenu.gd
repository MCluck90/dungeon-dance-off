extends "res://Scripts/Startup.gd"

func _on_StartButton_pressed():
	get_tree().change_scene("res://Levels/Level-01.tscn")


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://Credits.tscn")

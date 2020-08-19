extends "res://Scripts/LevelChanger.gd"

func _ready():
	pass # Replace with function body.

func _on_Key_collected_key():
	$Chest.open_chest()

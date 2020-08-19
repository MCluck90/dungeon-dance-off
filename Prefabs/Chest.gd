extends KinematicBody2D

signal next_level

export (String, FILE, "*.tscn,*.scn") var nextLevel

export (bool) var open

func _ready():
	if open:
		open_chest()

func on_player_collision():
	if !open:
		pass
	emit_signal("next_level", nextLevel)
	
func open_chest():
	$Sprite.region_rect.position.x = 144
	open = true

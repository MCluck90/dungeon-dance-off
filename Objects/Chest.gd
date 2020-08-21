extends "res://Grid/pawn.gd"

signal next_level

export (String, FILE, "*.tscn,*.scn") var nextLevel
export (bool) var open

func _ready():
	if open:
		unlock()
	
func unlock():
	$Sprite.region_rect.position.x = 144
	open = true

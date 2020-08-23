extends "res://Grid/pawn.gd"

signal next_level

export (String, FILE, "*.tscn,*.scn") var nextLevel
export (bool) var open
export var open_x = 144

func _ready():
	if open:
		unlock()
	
func unlock():
	$Sprite.region_rect.position.x = open_x
	open = true

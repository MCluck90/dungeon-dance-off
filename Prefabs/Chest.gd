extends KinematicBody2D

signal next_level

export (String) var NextLevel

var closed = true

func _ready():
	pass # Replace with function body.

func on_player_collision():
	if closed:
		pass
	emit_signal("next_level", NextLevel)
	
func open_chest():
	if closed:
		$Sprite.region_rect.position.x += 16
		closed = false

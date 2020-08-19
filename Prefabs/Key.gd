extends KinematicBody2D

signal collected_key

export (bool) var open

func on_player_collision():
	emit_signal("collected_key")
	queue_free()

extends Node2D

signal power
signal reset

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_SelectionBar_power_signal(power_level):
	emit_signal("power", power_level)


func _on_BeatBar_reset():
	$SelectionBar.emit_signal("reset_signal")

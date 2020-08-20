extends Node2D

signal power
signal reset


func _on_BeatBar_power(power_level):
	emit_signal("power", power_level)

func _on_BeatBar_reset():
	emit_signal("reset")

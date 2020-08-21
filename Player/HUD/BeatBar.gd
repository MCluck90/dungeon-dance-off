extends Node2D

signal power

func _ready():
	pass

func _on_SelectionBar_power_signal(power_level):
	emit_signal("power", power_level)

func _on_SelectionBar_reset_signal():
	$SelectionBar.emit_signal("reset_signal")

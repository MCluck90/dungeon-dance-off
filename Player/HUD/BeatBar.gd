extends Node2D

signal power

func _ready():
	pass

func _on_SelectionBar_power_signal(power_level):
	emit_signal("power", power_level)

func _on_SelectionBar_reset_signal():
	$SelectionBar.emit_signal("reset_signal")

func show_hit():
	var hit = $SelectionBar.duplicate()
	hit.remove_child(hit.get_child(0))
	hit.modulate.g = 0
	hit.modulate.b = 0
	add_child(hit)
	var timer = get_tree().create_timer($SelectionBar/Timer.wait_time * 3)
	yield(timer, "timeout")
	remove_child(hit)

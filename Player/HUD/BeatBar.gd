extends Node2D

signal power

var hit = null
var hit_timer = null

func _ready():
	pass
	
func _process(_delta):
	if hit_timer != null && hit_timer.get_time_left() <= 0.0:
		remove_child(hit)
		hit = null
		hit_timer = null

func _on_SelectionBar_power_signal(power_level):
	emit_signal("power", power_level)

func _on_SelectionBar_reset_signal():
	$SelectionBar.emit_signal("reset_signal")

func show_hit():
	hit = $SelectionBar.duplicate()
	hit.remove_child(hit.get_child(0))
	hit.modulate.g = 0
	hit.modulate.b = 0
	add_child(hit)
	hit_timer = get_tree().create_timer($SelectionBar/Timer.wait_time * 3)

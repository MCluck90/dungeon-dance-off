extends Sprite

signal power_signal

func _on_Timer_timeout():
	position.x += 16
	if position.x >= 160:
		position.x = 16
	var power_level = 0
	if position.x >= 64 && position.x <= 96:
		power_level = 1
	if position.x >= 112 && position.x <= 128:
		power_level = 2
	if position.x > 128:
		power_level = 3
	emit_signal("power_signal", power_level)

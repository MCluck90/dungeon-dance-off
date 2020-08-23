extends Sprite

signal power_signal

func _on_Timer_timeout():
	position.x += 16
	if position.x >= 176:
		position.x = 32
	var power_level = 0
	if position.x >= 80 && position.x <= 112:
		power_level = 1
	if position.x >= 128 && position.x <= 144:
		power_level = 2
	if position.x > 144:
		power_level = 3
	emit_signal("power_signal", power_level)

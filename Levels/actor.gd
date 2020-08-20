extends "pawn.gd"

onready var Grid = get_parent()

func _process(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return

	var target_position = Grid.request_move(self, input_direction)
	if target_position:
		move_to(target_position)
	else:
		print("collision")

func get_input_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func move_to(target_position):
	set_process(false)

	$Tween.interpolate_property(
		self,
		"position",
		position,
		target_position,
		0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN
	)

	$Tween.start()

	# Stop the function execution until the animation finished
	yield($Tween, "tween_completed")
	
	set_process(true)


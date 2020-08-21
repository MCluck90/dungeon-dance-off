extends "pawn.gd"

onready var Grid = get_parent()

var power_level = 0
var can_move = false

func _ready():
	$Camera2D.visible = true
	$Camera2D/CanvasLayer/HUD.visible = true

func _on_HUD_power(new_power_level):
	power_level = new_power_level
	if power_level == 0:
		can_move = true
	
func _process(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return
		
	can_move = false
	
	var target_level = 0
	for level in range(1, power_level + 1):
		match Grid.get_cell_movement_type(self, input_direction * level):
			"empty":
				target_level = level
			"stop":
				target_level = level
				break
			"solid":
				break
		
	if target_level > 0:
		var target_position = Grid.request_move(self, input_direction * target_level)
		move_to(target_position)

func get_input_direction():
	return Vector2(
		int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left")),
		int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
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


extends "pawn.gd"

onready var Grid = get_parent()
onready var Globals = get_node("/root/Globals")

var power_level = 0
var can_move = false

func _ready():
	# Allows us to hide all the HUD cruft when making levels
	$Camera2D.visible = true
	$Camera2D/CanvasLayer/HUD.visible = true

func _on_HUD_power(new_power_level):
	power_level = new_power_level
	if power_level == 0:
		can_move = true
	
func _process(_delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return
		
	can_move = false
	
	var target_level = 0
	var other = null
	for level in range(1, power_level + 1):
		var collision = Grid.get_collision(self, input_direction * level)
		match collision.type:
			"empty":
				target_level = level
			"stop":
				target_level = level
				break
			"collide":
				target_level = level - 1
				other = collision.node
				break
			"solid":
				break
		
	if target_level > 0:
		var target_position = Grid.request_move(self, input_direction * target_level, true)
		move_to(target_position)
		if other != null:
			other.on_collision(self)
	else:
		Grid.update_ais()

	Globals.add_to_score(target_level + 1)

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
	Grid.update_ais()


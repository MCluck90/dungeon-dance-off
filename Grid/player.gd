extends "pawn.gd"

onready var Grid = get_parent()
onready var Globals = get_node("/root/Globals")
onready var Mode = get_node("Camera2D/CanvasLayer/HUD/BeatBar/Mode")

var power_level = 0
var prev_power_level = 0
var can_act = false

func _ready():
	# Allows us to hide all the HUD cruft when making levels
	$Camera2D.visible = true
	$Camera2D/CanvasLayer/HUD.visible = true

func _on_HUD_power(new_power_level):
	prev_power_level = power_level
	power_level = new_power_level
	if power_level == 0 && prev_power_level != 0:
		can_act = true

func _process(_delta):
	prev_power_level = power_level

	if Input.is_action_just_pressed("prev_mode"):
		Mode.prev_mode()
	if Input.is_action_just_pressed("next_mode"):
		Mode.next_mode()

	if not can_act:
		return

	var input_direction = get_input_direction()
	if not input_direction:
		return

	Globals.add_to_score(1)

	can_act = false
	match Mode.mode:
		"move":
			move(input_direction)
		"attack":
			attack(input_direction)

func move(input_direction):
	var target_level = 0
	var other = null
	if power_level == 0:
		$MissedBeat.play()
	if power_level == 1:
		$Beat1.play()
	if power_level == 2:
		$Beat2.play()
	if power_level == 3:
		$Beat1.play()
		$Beat2.play()
		
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

func attack(input_direction):
	if power_level == 0:
		return Grid.update_ais()
	
	var collision = Grid.get_collision(self, input_direction * power_level)
	# Animate weapon
	var weapon = $Sword
	if power_level == 2:
		weapon = $Spear
	if power_level == 3:
		weapon = $Bow
	
	set_process(false)
	weapon.visible = true
	weapon.position = Vector2.ZERO
	weapon.get_node("SFX").play()
	
	var anim_speed = 0.2
	var tween = weapon.get_node("Tween")
	tween.interpolate_property(
		weapon,
		"position",
		weapon.position,
		input_direction * 16 * power_level,
		0.2 + (power_level - 1) * 0.1,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	tween.start()

	# Stop the function execution until the animation finished
	yield(tween, "tween_completed")
	
	weapon.visible = false
	
	set_process(true)
	
	if collision.has('node') && collision.node != null && collision.node.has_method('on_attack'):
		collision.node.on_attack()
		
	Grid.update_ais()

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


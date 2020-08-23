extends "res://Grid/pawn.gd"

onready var Grid = get_parent()
onready var Globals = get_node("/root/Globals")
onready var Mode = get_node("Camera2D/CanvasLayer/HUD/BeatBar/Mode")

var power_level = 0
var prev_power_level = 0
var can_act = true

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

	Globals.on_direction_input()
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
		$Beat3.play()
		
	var is_end_of_level = false
	for level in range(1, power_level + 1):
		var collision = Grid.get_collision(self, input_direction * level)
		match collision.type:
			"empty":
				target_level = level
			"stop":
				target_level = level
				is_end_of_level = collision.has("is_end_of_level") && collision.is_end_of_level
				break
			"collide":
				target_level = level - 1
				other = collision.node
				break
			"solid":
				break
		
	if target_level > 0:
		var target_position = Grid.request_move(self, input_direction * target_level, true)
		move_to(target_position, is_end_of_level)
		if other != null && other.has_method('on_collision'):
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

func move_to(target_position, is_end_of_level):
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
	if is_end_of_level:
		var node = Grid.get_cell_pawn(Grid.world_to_map(target_position))
		if node.open:
			return get_tree().change_scene(node.nextLevel)
	Grid.update_ais()

func on_hit(other, damage):
	set_process(false)
	
	var real_position = position
	var intermediate_position = Vector2(position.x, position.y)
	if other.position.x > position.x:
		intermediate_position.x -= 4
	elif other.position.x < position.x:
		intermediate_position.x += 4
	if other.position.y > position.y:
		intermediate_position.y -= 4
	elif other.position.y < position.y:
		intermediate_position.y += 4
		
	$Hurt.play()
		
	$Tween.interpolate_property(
		self,
		"position",
		position,
		intermediate_position,
		0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN
	)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	$Tween.interpolate_property(
		self,
		"position",
		intermediate_position,
		real_position,
		0.1,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	Globals.change_health(-damage)
	
	set_process(true)

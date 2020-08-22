extends "res://Grid/pawn.gd"

onready var Globals = get_node("/root/Globals")
onready var Grid = get_parent()

func update():
	var player = Globals.get_player()
	var diff = position - player.position
	var abs_diff = diff.abs() / 16.0
	if abs_diff.length() == 1:
		return player.on_hit(self, 1)
	
	var target_position = null
	var potential_direction = Vector2()
	if diff.x < 0:
		potential_direction.x = 1.0
	elif diff.x > 0:
		potential_direction.x = -1.0
	if diff.y < 0:
		potential_direction.y = 1.0
	elif diff.y > 0:
		potential_direction.y = -1.0

	var moved = false
	if potential_direction.x != 0.0:
		var direction = Vector2(potential_direction.x, 0.0)
		moved = _try_move(direction)
		
	if !moved && potential_direction.y != 0.0:
		var direction = Vector2(0.0, potential_direction.y)
		_try_move(direction)
	
func _try_move(direction):
	var target_position = Grid.request_move(self, direction, false)
	if target_position == null:
		return false
	position = target_position
	return true

func on_attack():
	Grid.remove_pawn(self)

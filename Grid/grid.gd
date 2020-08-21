extends TileMap

enum { EMPTY = -1, ACTOR, END_OF_LEVEL, KEY }

func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)
		
func get_child_at_pos(position):
	for child in get_children():
		if child.position == position:
			return child
		
func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return node

func get_cell_movement_type(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var cell_target_type = get_cellv(cell_target)
		
	match cell_target_type:
		EMPTY:
			return "empty"
		KEY:
			return "stop"
			
		END_OF_LEVEL:
			var node = get_cell_pawn(cell_target)
			if node.open:
				return "stop"
			else:
				return "solid"
	
	return "solid"

func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var cell_target_type = get_cellv(cell_target)
		
	match cell_target_type:
		EMPTY:
			return update_pawn_position(pawn, cell_start, cell_target)
			
		KEY:
			var object_pawn = get_cell_pawn(cell_target)
			object_pawn.unlock()
			object_pawn.queue_free()
			return update_pawn_position(pawn, cell_start, cell_target)

		END_OF_LEVEL:
			var node = get_cell_pawn(cell_target)
			if node.open:
				get_tree().change_scene(node.nextLevel)

func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, EMPTY)
	return map_to_world(cell_target)

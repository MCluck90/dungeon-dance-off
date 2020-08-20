extends TileMap

enum { EMPTY = -1, ACTOR, OBSTACLE, OBJECT }

func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)
		
func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)
			
func is_move_possible(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
		
	match cell_target_type:
		EMPTY:
			return true
			
	return false

func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
		
	match cell_target_type:
		EMPTY:
			return update_pawn_position(pawn, cell_start, cell_target)

func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, EMPTY)
	return map_to_world(cell_target)

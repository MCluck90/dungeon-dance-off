extends Node2D

enum CELL_TYPES {
	ACTOR,
	END_OF_LEVEL,
	KEY,
	AI
}
export(CELL_TYPES) var type = CELL_TYPES.ACTOR

extends "res://Grid/pawn.gd"

onready var Grid = get_parent()

export(String, "up", "down", "left", "right") var start_direction = "right"
export var steps_per_direction = 2

var to_direction = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN,
}
var next_state = {
	"right": "down",
	"down": "left",
	"left": "up",
	"up": "right"
}

var state = "right"
var steps_remaining = 2

func _ready():
	state = start_direction
	steps_remaining = steps_per_direction

func update():
	var target_position = null
	for _i in range(0, 4):
		var direction = to_direction[state]
		target_position = Grid.request_move(self, direction, false)
		if target_position == null:
			change_direction()
		else:
			break

	if target_position != null:
		position = target_position
		steps_remaining -= 1
		if steps_remaining <= 0:
			change_direction()

func change_direction():
	state = next_state[state]
	steps_remaining = 2

func on_collision(_other):
	pass

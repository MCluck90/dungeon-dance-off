extends Sprite

export(String, "move", "attack") var mode = "move"

var mode_to_offset = {
	"move": Vector2(688, 160),
	"attack": Vector2(512, 128)
}

var mode_state_transitions = {
	"move": "attack",
	"attack": "move"
}

func _ready():
	set_sprite()

func next_mode():
	mode = mode_state_transitions[mode]
	set_sprite()
	return mode

func prev_mode():
	var other_mode = mode_state_transitions[mode]
	while mode_state_transitions[other_mode] != mode:
		other_mode = mode_state_transitions[other_mode]
	mode = other_mode
	set_sprite()
	return mode

func set_sprite():
	region_rect.position = mode_to_offset[mode]

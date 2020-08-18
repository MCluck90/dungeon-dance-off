extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tile_size = 16
var inputs = {
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
	"ui_left": Vector2.LEFT,
	"ui_right": Vector2.RIGHT
}

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for dir in inputs.keys():
		if Input.is_action_just_pressed(dir):
			move(dir)
			
func move(dir):
	$RayCast2D.cast_to = inputs[dir] * tile_size * 0.99
	$RayCast2D.force_raycast_update()
	if !$RayCast2D.is_colliding():
		position += inputs[dir] * tile_size

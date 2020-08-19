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
var power_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for dir in inputs.keys():
		if Input.is_action_just_pressed(dir):
			move(dir)
			
func move(dir):
	$Camera2D/CanvasLayer/BeatBar.emit_signal("reset")
	for power in range(power_level, 0, -1):
		$RayCast2D.cast_to = inputs[dir] * tile_size * power
		$RayCast2D.force_raycast_update()
		var collider = $RayCast2D.get_collider()
		if collider != null && collider.has_method("on_player_collision"):
			collider.on_player_collision()
		if collider == null || collider.is_in_group("pass-through"):
			position += inputs[dir] * tile_size * power
			break
		elif collider.is_in_group("chest"):
			collider.open_chest()
			break
		


func _on_BeatBar_power(new_power_level):
	power_level = new_power_level

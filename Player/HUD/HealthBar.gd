extends Node2D

onready var Globals = get_node("/root/Globals")
var health = 3

func _ready():
	$BaseHeart.visible = false
	set_hearts()
	
func change_health(delta):
	health += delta
	health = max(health, 0)
	if health == 0:
		return Globals.on_death()
	set_hearts()
	
func set_hearts():
	for child in get_children():
		if child.is_in_group("sub-heart"):
			child.queue_free()
	
	for i in range(0, health, 1):
		var heart = $BaseHeart.duplicate()
		heart.add_to_group("sub-heart")
		heart.visible = true
		heart.position.x = -16.0 * i
		self.add_child(heart)

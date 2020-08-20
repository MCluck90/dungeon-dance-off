extends Node2D

var health = 3

func _ready():
	$BaseHeart.visible = false
	set_hearts()
	
func change_health(delta):
	health += delta
	
func set_hearts():
	for child in get_children():
		if child.is_in_group("sub-heart"):
			remove_child(child)
	
	for i in range(0, health, 1):
		var heart = $BaseHeart.duplicate()
		heart.add_to_group("sub-heart")
		heart.visible = true
		heart.position.x = -16.0 * i
		self.add_child(heart)

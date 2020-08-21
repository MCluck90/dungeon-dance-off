extends Node2D

onready var Globals = get_node("/root/Globals")

func _ready():
	# Remove the sprite. It's only there so we can see it when putting together the HUD
	$Sprite.queue_free()
	set_score()

func set_score():
	# Reset to nothing
	for i in range(0, 10):
		$TileMap.set_cell(i, 0, -1)

	var digits = []
	var num = Globals.score
	while num >= 10:
		digits.push_front(num % 10)
		num = num / 10

	for i in range(0, len(digits)):
		$TileMap.set_cell(i + 1, 0, digits[i])
	$TileMap.set_cell(0, 0, num)


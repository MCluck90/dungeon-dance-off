extends "res://Grid/pawn.gd"

onready var Grid = get_parent()
onready var MusicManager = get_node("/root/MusicManager")

var dying = false

func update():
	if dying:
		return

	var collisions = [
		Grid.get_collision(self, Vector2.LEFT),
		Grid.get_collision(self, Vector2.RIGHT),
		Grid.get_collision(self, Vector2.UP),
		Grid.get_collision(self, Vector2.DOWN)
	]
	
	var exploded = false
	for collision in collisions:
		if collision != null && collision.has("node"):
			var node = collision.node
			if node.has_method("on_attack"):
				node.on_attack()
				exploded = true
			elif node.has_method("on_hit"):
				node.on_hit(self, 1)
				exploded = true

	if exploded:
		MusicManager.get_node("Explosion").play()
		dying = true
		$Tween.interpolate_property(
			$Sprite,
			"modulate",
			Color(1, 1, 1, 1),
			Color(1, 1, 1, 0.0),
			0.15,
			Tween.TRANS_CUBIC, Tween.EASE_OUT
		)
		$Tween.interpolate_property(
			$Sprite,
			"scale",
			$Sprite.scale,
			Vector2(1.2, 1.2),
			0.15,
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		$Tween.interpolate_property(
			$Sprite,
			"offset",
			$Sprite.offset,
			Vector2(-6, -2),
			0.15,
			Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		$Tween.start()
		yield($Tween, "tween_completed")
		Grid.remove_pawn(self)

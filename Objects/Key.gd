extends "res://Grid/pawn.gd"

export (NodePath) var unlockable

func unlock():
	var node = get_node(unlockable)
	node.unlock()

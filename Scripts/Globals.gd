extends Node

var score = 0
var _score_node = null

func _ready():
	_score_node = null

func _find_score_node(node):
	if node.has_method("is_in_group") && node.is_in_group("score"):
		return node

	for child in node.get_children():
		var result = _find_score_node(child)
		if result != null:
			return result

func _get_score_node():
	if _score_node != null:
		return _score_node

	_score_node = _find_score_node(get_node("/root"))
	return _score_node

func add_to_score(delta):
	score += delta
	_get_score_node().set_score()
	
func set_score(new_score):
	score = new_score
	_get_score_node().set_score()

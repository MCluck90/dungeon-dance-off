extends Node

var score = 0
var _score_node = null
var _health_node = null
var _beatbar_node = null
var _player_node = null

func _ready():
	_score_node = null
	_health_node = null
	_beatbar_node = null
	_player_node = null

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

func _find_health_node(node):
	if node.name == 'HealthBar':
		return node

	for child in node.get_children():
		var result = _find_health_node(child)
		if result != null:
			return result

func _get_health_node():
	if _health_node != null:
		return _health_node

	_health_node = _find_health_node(get_node("/root"))
	return _health_node

func change_health(delta):
	_get_health_node().change_health(delta)

func _find_beatbar_node(node):
	if node.name == 'BeatBar':
		return node
		
	for child in node.get_children():
		var result = _find_beatbar_node(child)
		if result != null:
			return result
			
func _get_beatbar_node():
	if _beatbar_node != null:
		return _beatbar_node

	_beatbar_node = _find_beatbar_node(get_node("/root"))
	return _beatbar_node
			
func on_direction_input():
	_get_beatbar_node().show_hit()
	
func _find_player_node(node):
	if node.name == 'Player':
		return node
		
	for child in node.get_children():
		var result = _find_player_node(child)
		if result != null:
			return result
			
func _get_player_node():
	if _player_node != null:
		return _player_node

	_player_node = _find_player_node(get_node("/root"))
	return _player_node
	
func get_player():
	return _get_player_node()

func on_death():
	get_node("/root/Level").on_death()
	
func change_scene(scene_path):
	_ready()
	return get_tree().change_scene(scene_path)

func reload_current_scene():
	_ready()
	return get_tree().reload_current_scene()
